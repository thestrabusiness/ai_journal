class AnalyzeJournalEntry
  def initialize(journal_entry)
    @journal_entry = journal_entry
  end

  def self.run(journal_entry)
    new(journal_entry).run
  end

  def run
    analysis = FetchJournalEntryAnalysis.run(journal_entry)
    relationship_analysis = FetchJournalEntryRelationshipAnalysis.run(journal_entry)

    people = relationship_analysis.map do |analysis|
      Person.find_or_create_by(name: analysis[:name]).tap do |person|
        embeddings = FetchEmbeddings.run(analysis[:summary])
        embeddings.each do |embedding|
          person.embeddings.create(
            content: embedding[:chunk_text],
            embedding: embedding[:embedding],
            journal_entry:
          )
        end
      end
    end

    journal_entry.update(analysis:, people:)
  end

  private

  attr_reader :journal_entry
end
