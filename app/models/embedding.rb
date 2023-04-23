class Embedding < ApplicationRecord
  belongs_to :embeddable, polymorphic: true

  has_neighbors :embedding, dimensions: 1536

  validates :content, presence: true
  validates :embedding, presence: true
end
