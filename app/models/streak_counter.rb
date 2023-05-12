class StreakCounter
  def initialize(records)
    @records = records
  end

  def current_streak
    streak = 0
    streak_offset = 0

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

  # TODO: It might be better to use a SQL query to find the longest streak in
  # the future, but this works for now.
  def longest_streak
    last_record_date = Date.today
    longest_streak = 0
    streak = 0

    records.each do |record|
      # If we subtract the streak from the last record date and the result
      # doesn't match the record's date, we've found the first record that
      # breaks the streak.
      if record.created_at.to_date == last_record_date - streak
        # Otherwise, increment the streak
        streak += 1
      else
        # If the streak we just found is longer than the longest streak we've
        # found so far, set it as the longest streak
        longest_streak = streak if streak > longest_streak

        # Set the last record date to the date of the record we just found
        last_record_date = record.created_at.to_date

        # Set the streak to 1, since we've found an record for the last day
        streak = 1
      end
    end

    longest_streak
  end

  private

  attr_reader :records
end
