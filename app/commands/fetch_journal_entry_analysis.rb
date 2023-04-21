class FetchJournalEntryAnalysis
  def initialize(journal_entry)
    @journal_entry = journal_entry
  end

  def self.run(journal_entry)
    new(journal_entry).run
  end

  def run
    FetchChatCompletion.run(conversation_entries)
  end

  private

  attr_reader :journal_entry

  def conversation_entries
    [
      { role: 'user', content: analysis_instruction_text },
      { role: 'user', content: journal_entry_content }
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

      Prompt the me to to think about the following questions. Reflect on
      possible answers to each of these based on your analysis of the entry.
      Approach your suggestions with openess, as a coach or mentor, not as a
      parent or teacher. The goal is to help me reflect on what I've written. We
      want to encourage open and expansive thinking.

      Possible ways to start your reflections:
       - It looks like you might be learning...
       - Based on what you've written, I'm curious about ...
       - Its interesting that you mention... in a year from now I wonder if...

      ----

      The Prompts:

      Describe one thing you learned from today's entry. How might you use this insight in your life moving forward?

      Based on what you've written, what is one action you could take to improve your situation or make progress towards a goal?

      Imagine you're reading this entry a year from now. What advice would you give yourself based on what you've written today?

      Reflect on a specific sentence or paragraph in your entry that stands out to you. What does it reveal about your thoughts or feelings?

      If you could go back in time and talk to yourself before writing this entry, what advice or insight would you offer?

      ---

      Write your response like this

      <span class="text-lg font-medium">1. Describe one thing you've learning ... {the rest of the prompt}</span>

      It looks like you might be learning...

      Do that with each of the prompts

    TEXT
  end
end
