class CoreValue < ApplicationRecord
  validates :name, :description, presence: true
end
