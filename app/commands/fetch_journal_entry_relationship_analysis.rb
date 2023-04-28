class FetchJournalEntryRelationshipAnalysis
  def initialize(journal_entry)
    @journal_entry = journal_entry
  end

  def self.run(journal_entry)
    new(journal_entry).run
  end

  def run
    client = OpenAI::Client.new
    response = client.completions(completion_params)
    raw_text = response.dig('choices', 0, 'text')
    JSON.parse(raw_text, symbolize_names: true)
  end

  private

  attr_reader :journal_entry

  def completion_params
    {
      parameters: {
        max_tokens: 1000,
        model: 'text-davinci-003',
        prompt:,
        temperature: 0
      }
    }
  end

  def prompt
    <<~PROMPT
      #{journal_entry.content}

      ---

      Generate a list of the people metioned in the above text. Make it a list
      of JSON objects with name and summary key-value pairs. The summary should
      describe overall sentiment and my relationship to them in the context of
      the entry. Is our relationship improving? Changing? Static? You may infer
      my relationship to them if you are familiar with the name given or leave
      it out if you can't tell. You can only include valid JSON in your response.
    PROMPT
  end
end
