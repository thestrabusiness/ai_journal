class AnalyzeJournalEntry
  def initialize(journal_entry)
    @journal_entry = journal_entry
    @user = journal_entry.user
  end

  def self.run(journal_entry)
    new(journal_entry).run
  end

  def run
    ActiveRecord::Base.transaction do
      # Fetch an analysis of the journal entry content
      analysis = FetchJournalEntryAnalysis.run(journal_entry)
      # Fetch a summary of the relationships in the journal entry content
      relationship_analysis = FetchJournalEntryRelationshipAnalysis.run(journal_entry)
      # Process the analysis and relationship analysis into relationships and
      # embeddings
      relationships = relationship_analysis.map do |relationship_data|
        process_relationship_analysis(relationship_data)
      end
      # Update the journal entry with the analysis and relationships
      journal_entry.update(analysis:, relationships:)
    end
  end

  private

  attr_reader :journal_entry, :user

  def build_relationship_summary_for_entry(relationship, embedding_data)
    relationship.relationship_summaries.build(
      content: embedding_data[:chunk_text],
      created_at: journal_entry.created_at,
      embedding: embedding_data[:embedding],
      journal_entry:
    )
  end

  def clear_existing_relationship_summaries(relationships)
    relationships.relationship_summaries.where(journal_entry:).destroy_all
  end

  def process_relationship_analysis(relationship_data)
    user
      .relationships
      .find_or_create_by(name: relationship_data[:name])
      .tap do |relationship|
        generated_embeddings = FetchEmbeddings.run(relationship_data[:summary])

        clear_existing_relationship_summaries(relationship)
        generated_embeddings.each do |embedding|
          build_relationship_summary_for_entry(relationship, embedding)
        end

        relationship.save!
        relationship.relationship_summaries.each(&:save!)
      end
  end
end
