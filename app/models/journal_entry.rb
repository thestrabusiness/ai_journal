class JournalEntry < ApplicationRecord
  include DisplayTitle

  belongs_to :user
  has_and_belongs_to_many :relationships
  has_many :chat_logs, dependent: :destroy
  has_many :embeddings, dependent: :destroy, class_name: "JournalEntryEmbedding"
  has_many :relationship_summaries

  has_rich_text :content

  validates :user, presence: true

  after_save :generate_content_embeddings

  def analyze!
    AnalyzeJournalEntry.run(self)
  end

  def self.matching_query(query_embedding, similarity_threshold: 0.7)
    similarity_score_sql = Arel.sql("1 - (journal_entry_embeddings.embedding <=> '#{query_embedding}')")
    left_joins(:embeddings)
      .select("journal_entries.*, MAX(#{similarity_score_sql}) AS similarity_score")
      .where("#{similarity_score_sql} > #{similarity_threshold}")
      .group("journal_entries.id")
      .order(Arel.sql("similarity_score DESC"))
  end

  private

  def generate_content_embeddings
    ActiveRecord::Base.transaction do
      embeddings.destroy_all
      embedding_data = FetchEmbeddings.run(content.to_plain_text)
      embedding_data.each do |data|
        embeddings.create!(
          content: data[:chunk_text],
          embedding: data[:embedding]
        )
      end
    end
  end
end
