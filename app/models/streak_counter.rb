class StreakCounter
  def initialize(klass)
    unless klass < ActiveRecord::Base
      raise ArgumentError, "provided class must be an ActiveRecord class"
    end

    unless klass.column_names.include?("created_at")
      raise ArgumentError, "provided class must have a created_at column"
    end

    @klass = klass
  end

  def current_streak
    streak = 0
    streak_offset = 0
    # We only want to count one record per day, so we need to use DISTINCT
    # and group by the date portion of the created_at timestamp
    records = klass.order(created_at: :desc).distinct("date(created_at)")

    records.each.with_index do |record, index|
      # Check for a streak whose last record was created yesterday. Keep this
      # streak until a whole day has passed
      if streak.zero? && index.zero? && record.created_at.to_date == Date.yesterday
        streak += 1
        streak_offset += 1
        next
      end

      if record.created_at.to_date == Date.today - (streak + streak_offset)
        streak += 1
        next
      end

      break
    end

    streak
  end

  def longest_streak
    result = ActiveRecord::Base.connection.execute(longest_streak_sql)
    result.first["longest_streak"]
  end

  private

  # This SQL query is currently assuming that the user is in the Eastern time
  # zone. Once I have a user model, I can use the user's time zone instead. This
  # just makes it possible to get the correct streaks for the current day for my
  # own data.
  def longest_streak_sql
    <<~SQL
      WITH converted_dates AS (
        SELECT (created_at AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York')::date AS created_date
        FROM #{klass.table_name}
      ),
      ranked_records AS (
        SELECT created_date, RANK() OVER (ORDER BY created_date) AS r
        FROM converted_dates
        GROUP BY created_date
        ORDER BY created_date
      ),
      streaks AS (
        SELECT created_date, created_date - INTERVAL '1 day' * r AS grouping
        FROM ranked_records
      ),
      grouped_streaks AS (
        SELECT COUNT(*) AS streak_length, MIN(created_date) AS streak_start
        FROM streaks
        GROUP BY grouping
        ORDER BY streak_length DESC
      )
      SELECT MAX(streak_length) AS longest_streak
      FROM grouped_streaks;
    SQL
  end

  attr_reader :klass
end
