module JournalEntriesHelper
  def current_streak_text
    "Current streak: #{current_streak} day".pluralize(current_streak)
  end

  def longest_streak_text
    "Longest streak: #{longest_streak} day".pluralize(longest_streak)
  end

  def analysis_confirmation
    return unless @journal_entry.analysis.present?

    { "turbo-confirm" => "This will replace the current AI reflection. Are you sure?" }
  end

  private

  def current_streak
    @current_streak ||= streak_counter.current_streak
  end

  def longest_streak
    @longest_streak ||= streak_counter.longest_streak
  end

  def streak_counter
    @streak_counter ||= StreakCounter.new(JournalEntry)
  end
end
