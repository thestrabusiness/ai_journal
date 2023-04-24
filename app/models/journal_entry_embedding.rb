class JournalEntryEmbedding < ApplicationRecord
  belongs_to :journal_entry

  has_neighbors :embedding, dimensions: 1536

  validates :content, presence: true
  validates :embedding, presence: true
end
