class GeneratePulseCheck
  def self.run!
    new.run
  end

  def run
    raw_response = FetchChatCompletion.run(
      [{ role: "user", content: prompt_text }],
      model: FetchChatCompletion::Models::GPT_4
    )

    json = JSON.parse(raw_response, symbolize_names: true)

    PulseCheck.create!(
      summary: json[:summary],
      core_value_scores: json[:scores]
    )
  end

  private

  def latest_journal_entries
    JournalEntry.with_all_rich_text.last(10)
  end

  def core_value_text
    CoreValue.find_each.map do |core_value|
      "#{core_value.name}: #{core_value.description}"
    end.join("\n")
  end

  def prompt_text
    <<~TEXT

      For each of my values, I want to know how I'm doing. Give me a score for
      each of my values based on how well I'm related to them. Use the following
      journal entries as the material used to scored.

      # Entries
      #{latest_journal_entries.map(&:content).join("\n")}

      # Values
      #{core_value_text}

      For each value, give me a score from 1 to 10, where 1 is not at all and
      10 is completely. For example, if I'm completely aligned with  a value, I
      would give it a 10. If I'm not at all aligned with a value, I would give it
      a 1.

      Return your response in the following format

      {
        "summary": "Some string summarizing the pulse check based on the given journal entries",
        "scores": [
          { "name": "Value Name", "score": 10, "reasoning": "You are completely aligned with this value because..." },
          { "name": "Other Value Name", "score": 1, "reasoning": "You are not at all aligned with this value because..." },
        ],
      }

      Only return valid JSON.
    TEXT
  end
end
