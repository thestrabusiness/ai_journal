class FetchJournalEntryAnalysis
  def initialize(journal_entry)
    @journal_entry = journal_entry
  end

  def self.run(journal_entry)
    new(journal_entry).run
  end

  def run
    FetchChatCompletion.run(
      conversation_entries,
      model: FetchChatCompletion::Models::GPT_4
    )
  end

  private

  attr_reader :journal_entry

  def conversation_entries
    [
      { role: "user", content: analysis_instruction_text },
      { role: "user", content: journal_entry_content }
    ]
  end

  def journal_entry_content
    prompt_parts = []
    prompt_parts << journal_entry.title if journal_entry.title.present?
    prompt_parts << journal_entry.content
    prompt_parts.join("\n\n")
  end

  def analysis_instruction_text
    <<~TEXT

      Reflect back to the user what's going on in their journal entry.

      Break down the major themes of the journal entry and reflect back to the
      user where you think they are, where they've been and what they might be
      trying to work out.

      If the user isn't sorting out a problem, then reflect back to them what you
      think is important about what they wrote.

      Possible ways to start your reflections:
       - It looks like you might be learning...
       - Based on what you've written, I'm curious about ...
       - Its interesting that you mention... I wonder in a year form now how...

       You can use html tags to format your response, along with tailwind
       classes, to highlight any important ideas. You don't neee to use any br
       tags, just use newlines to separate your paragraphs. Only use up to 2 new
       lines between paragraphs. Don't start your response with any newlines.

    TEXT
  end
end
