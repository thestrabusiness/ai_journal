class PulseCheck < ApplicationRecord
  validates :summary, presence: true
  validates :core_value_scores, presence: true
end
