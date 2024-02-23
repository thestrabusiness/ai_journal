class User < ApplicationRecord
  include Clearance::User

  has_many :chat_logs, dependent: :destroy
  has_many :core_values, dependent: :destroy
  has_many :journal_entries, dependent: :destroy
  has_many :pulse_checks, dependent: :destroy
  has_many :relationships, dependent: :destroy
end
