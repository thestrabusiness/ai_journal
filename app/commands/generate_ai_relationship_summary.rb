class GenerateAiRelationshipSummary
  def initialize(relationship:)
    @relationship = relationship
  end

  def self.run(relationship:)
    new(relationship:).run
  end

  def run
    client = OpenAI::Client.new
    response = client.completions(parameters: completion_params)
    response_text = response.dig("choices", 0, "text")
    embeddings = FetchEmbeddings.run(response_text)

    {
      content: response_text,
      embedding: embeddings.first[:embedding]
    }
  end

  private

  attr_reader :relationship

  def completion_params
    {
      max_tokens: 1000,
      model: "text-davinci-003",
      prompt:,
      temperature: 0
    }
  end

  def recent_summary_content
    relationship
      .relationship_summaries
      .order(created_at: :desc)
      .map do |summary|
        <<~SUMMARY
          #{summary.created_at.strftime('%B %-d, %Y')}
          #{summary.content.to_plain_text}
        SUMMARY
      end.join("\n\n")
  end

  def prompt
    <<~PROMPT

      The following text is comprised of entries from my journal that describe
      my relationship to #{relationship.name}.

      Given the text below, write a summary of the relationship. Is the
      relationship changing? Improving? Staying the same? Deteriorating? What's
      interesting about the progression over the past few entries? What's
      interesting about the relationship itself? What should I know about the
      relationship that I might not realize? Don't word your summary exactly as
      prompted.

      Recent entries for this relationship:
      #{recent_summary_content}

      ---

    PROMPT
  end
end
