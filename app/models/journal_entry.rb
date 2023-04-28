class JournalEntry < ApplicationRecord
  has_many :chat_logs, dependent: :destroy
  has_many :embeddings, dependent: :destroy, class_name: "JournalEntryEmbedding"
  has_and_belongs_to_many :people
  has_many :relationship_summary_embeddings, through: :people, source: :embeddings

  has_rich_text :content

  after_save :generate_content_embeddings

  def analyze!
    AnalyzeJournalEntry.run(self)
  end

  def created_at_string
    created_at.strftime("%B %-d, %Y")
  end

  def display_title
    if persisted?
      title.present? ? title_with_date : created_at_string
    else
      Date.today.strftime("%B %-d, %Y")
    end
  end

  def title_with_date
    "#{created_at_string}: #{title}"
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
