class GenerateAiRelationshipSummary
  def initialize(relationship:)
    @relationship = relationship
  end

  def self.run(relationship:)
    new(relationship:).run
  end

  def run
    response = FetchChatCompletion.run(
      [{ role: "user", content: prompt }],
      model: FetchChatCompletion::Models::GPT_4_TURBO_PREVIEW
    )
    embeddings = FetchEmbeddings.run(response)

    {
      content: response,
      embedding: embeddings.first[:embedding]
    }
  end

  private

  attr_reader :relationship

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
