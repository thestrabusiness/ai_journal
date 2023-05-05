class RelationshipSummary < ApplicationRecord
  belongs_to :person
  belongs_to :journal_entry, optional: true

  has_neighbors :embedding, dimensions: 1536

  validates :content, presence: true
  validates :embedding, presence: true
end
