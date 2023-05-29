class Relationship < ApplicationRecord
  has_and_belongs_to_many :journal_entries
  has_many :relationship_summaries, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
