class JournalEntry < ApplicationRecord
  include DisplayTitle

  has_many :chat_logs, dependent: :destroy
  has_many :embeddings, dependent: :destroy, class_name: "JournalEntryEmbedding"
  has_and_belongs_to_many :relationships
  has_many :relationship_summaries

  has_rich_text :content

  after_save :generate_content_embeddings

  def analyze!
    AnalyzeJournalEntry.run(self)
  end

  private

  def generate_content_embeddings
    embedding_data = FetchEmbeddings.run(content.to_plain_text)
    embedding_data.each do |data|
      embeddings.create!(
        content: data[:chunk_text],
        embedding: data[:embedding]
      )
    end
  end
end
