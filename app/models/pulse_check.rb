class PulseCheck < ApplicationRecord
  belongs_to :user

  validates :core_value_scores, :summary, :user, presence: true
end
