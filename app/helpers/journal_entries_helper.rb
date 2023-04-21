module JournalEntriesHelper
  def current_streak_text
    "Current streak: #{current_streak} day".pluralize(current_streak)
  end

  def longest_streak_text
    "Longest streak: #{longest_streak} day".pluralize(longest_streak)
  end

  def analysis_confirmation
    return unless @journal_entry.analysis.present?

    { 'turbo-confirm' => 'This will replace the current AI reflection. Are you sure?' }
  end

  private

  def current_streak
    streak = 0

    journal_entries_distinct_by_date.each do |entry|
      # If we subtract the streak from today's date and the result doesn't match
      # the entry's date, we've found the first entry that breaks the streak.
      break if entry.created_at.to_date != Date.today - streak

      # Otherwise, increment the streak
      streak += 1
    end

    streak
  end

  # TODO: It might be better to use a SQL query to find the longest streak in
  # the future, but this works for now.
  def longest_streak
    last_entry_date = Date.today
    longest_streak = 0
    streak = 0

    journal_entries_distinct_by_date.each do |entry|
      # If we subtract the streak from the last entry date and the result
      # doesn't match the entry's date, we've found the first entry that breaks
      # the streak.
      if entry.created_at.to_date != last_entry_date - streak
        # If the streak we just found is longer than the longest streak we've
        # found so far, set it as the longest streak
        longest_streak = streak if streak > longest_streak

        # Set the last entry date to the date of the entry we just found
        last_entry_date = entry.created_at.to_date

        # Set the streak to 1, since we've found an entry for the last day
        streak = 1
      else
        # Otherwise, increment the streak
        streak += 1
      end
    end

    longest_streak
  end

  # We only want to count the number of days that the user has made entries, so
  # we'll use the distinct method to only return one entry per day.
  def journal_entries_distinct_by_date
    JournalEntry.order(created_at: :desc).distinct(:created_at)
  end
end
