class Relationship < ApplicationRecord
  belongs_to :user

  has_and_belongs_to_many :journal_entries
  has_many :relationship_summaries, dependent: :destroy

  validates :name, :user, presence: true
  validates :name, uniqueness: true
end
