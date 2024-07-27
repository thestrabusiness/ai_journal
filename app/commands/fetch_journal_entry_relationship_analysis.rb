class FetchJournalEntryRelationshipAnalysis
  def initialize(journal_entry)
    @journal_entry = journal_entry
  end

  def self.run(journal_entry)
    new(journal_entry).run
  end

  def run
    raw_text = FetchChatCompletion.run(
      conversation_entries,
      model: FetchChatCompletion::Models::GPT_4_TURBO,
      response_type: "json_object"
    )

    JSON.parse(raw_text, symbolize_names: true)[:people]
  end

  private

  attr_reader :journal_entry

  def conversation_entries
    [{ role: "user", content: analysis_instruction_text }]
  end

  def analysis_instruction_text
    <<~PROMPT
      #{journal_entry.content}

      ---

      Generate a list of the people metioned in the above text. Make it a list
      of JSON objects with name and summary key-value pairs. The summary should
      describe overall sentiment and my relationship to them in the context of
      the entry. Is our relationship improving? Changing? Static? You may infer
      my relationship to them if you are familiar with the name given or leave
      it out if you can't tell. Refer to the writer exclusively as "you". You
      can only include valid JSON in your response.

      {
        "people": [
          { "name": "Person Name", "summary": "Some summary of my relationship to this person" },
          { "name": "Other Person Name", "summary": "Some summary of my relationship to this person" },
        ]
      }

    PROMPT
  end
end
