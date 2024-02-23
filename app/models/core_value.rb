class CoreValue < ApplicationRecord
  belongs_to :user

  validates :description, :user, :name, presence: true
end
