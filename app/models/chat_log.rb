class ChatLog < ApplicationRecord
  belongs_to :journal_entry, optional: true

  validate :validate_conversation_entries_format

  after_initialize :set_system_role, if: :new_record?

  def self.entry_class(entry)
    entry['role'] == 'user' ? 'user-chat-bubble' : 'ai-chat-bubble'
  end

  def add_user_entry(content)
    conversation_entries << {
      'role' => 'user',
      'content' => content,
      'created_at' => Time.current.to_s
    }
    save!
  end

  def entries_for_display
    conversation_entries
      .sort_by { |entry| entry['created_at'] }
      .reject { |entry| entry['role'] == 'system' }
  end

  def serialize_conversation_entries
    conversation_entries.map do |entry|
      {
        content: entry['content'],
        role: entry['role']
      }
    end
  end

  private

  def set_system_role
    conversation_entries << {
      'role' => 'system',
      'content' => 'You are a helpful assistant.',
      'created_at' => Time.current.to_s
    }
  end

  def validate_conversation_entries_format
    conversation_entries.each do  |entry|
      unless entry.is_a?(Hash) && entry_valid?(entry)
        errors.add(:conversation_entries, "Invalid entry format: #{entry.inspect}")
      end
    end
  end

  def entry_valid?(entry)
    entry.keys.sort == %w[content created_at role] &&
      entry['role'].is_a?(String) &&
      entry['content'].is_a?(String) &&
      Time.parse(entry['created_at']).is_a?(Time)
  end
end
