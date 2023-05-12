class RelationshipSummary < ApplicationRecord
  include DisplayTitle

  belongs_to :relationship
  belongs_to :journal_entry, optional: true

  has_neighbors :embedding, dimensions: 1536

  has_rich_text :content

  validates :embedding, presence: true

  before_save :generate_content_embeddings

  def display_title
    if journal_entry
      journal_entry.display_title
    else
      super
    end
  end

  private

  def generate_content_embeddings
    return if content.blank? || embedding.present?

    embedding_data = FetchEmbeddings.run(content.to_plain_text)
    self.embedding = embedding_data.first[:embedding]
  end
end
