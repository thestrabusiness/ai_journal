class Person < ApplicationRecord
  has_and_belongs_to_many :journal_entries
  has_many :embeddings, dependent: :destroy, class_name: 'RelationshipSummaryEmbedding'

  validates :name, presence: true, uniqueness: true
end
