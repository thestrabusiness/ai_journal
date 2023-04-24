class AnalyzeJournalEntry
  def initialize(journal_entry)
    @journal_entry = journal_entry
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
      # Process the analysis and relationship analysis into people and embeddings
      people = relationship_analysis.map do |person_data|
        process_relationship_analysis(person_data)
      end
      # Update the journal entry with the analysis and people
      journal_entry.update(analysis:, people:)
    end
  end

  private

  attr_reader :journal_entry

  def create_embedding_for_entry(person, embedding_data)
    person.embeddings.create!(
      content: embedding_data[:chunk_text],
      embedding: embedding_data[:embedding],
      journal_entry:
    )
  end

  def clear_existing_embeddings_for_entry(person)
    person.embeddings.where(journal_entry:).destroy_all
  end

  def process_relationship_analysis(person_data)
    Person.find_or_create_by(name: person_data[:name]).tap do |person|
      generated_embeddings = FetchEmbeddings.run(person_data[:summary])
      clear_existing_embeddings_for_entry(person)
      generated_embeddings.each { |embedding| create_embedding_for_entry(person, embedding) }
    end
  end
end
