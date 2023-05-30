class ChatLog < ApplicationRecord
  belongs_to :journal_entry, optional: true

  validate :validate_conversation_entries_format

  after_initialize :init_system_role, if: :new_record?

  enum kind: {
    question: "question",
    chat: "chat"
  }

  def self.entry_class(entry)
    entry["role"] == "user" ? "user-chat-bubble" : "ai-chat-bubble"
  end

  def add_user_entry(content, context = nil)
    add_entry("user", content, context)
    fetch_assistant_response
  end

  def entries_for_display
    conversation_entries
      .sort_by { |entry| entry["created_at"] }
      .reject { |entry| entry["role"] == "system" }
  end

  private

  def add_assistant_response(content)
    add_entry("assistant", content)
  end

  def add_entry(role, content, context = nil)
    conversation_entries << {
      "role" => role,
      "content" => content,
      "created_at" => Time.current.to_s,
      "context" => context
    }
  end

  def conversation_entries_for_assistant_request
    conversation_entries
      .sort_by { |entry| entry["created_at"] }
      .map do |entry|
        {
          content: "#{entry['context']}\n\n #{entry['content']}}".strip,
          role: entry["role"]
        }
      end
  end

  def entry_valid?(entry)
    entry.keys.sort == %w[content context created_at role] &&
      entry["role"].is_a?(String) &&
      entry["content"].is_a?(String) &&
      (entry["context"].is_a?(String) || entry["context"].nil?) &&
      Time.parse(entry["created_at"]).is_a?(Time)
  end

  def fetch_assistant_response
    new_assistant_response = FetchChatCompletion.run(conversation_entries_for_assistant_request)
    add_assistant_response(new_assistant_response)
  end

  def init_system_role
    if question?
      add_entry("system", question_system_role)
    else
      add_entry("system", "You are a helpful assistant.")
    end
  end

  def validate_conversation_entries_format
    conversation_entries.each do  |entry|
      unless entry.is_a?(Hash) && entry_valid?(entry)
        errors.add(:conversation_entries, "Invalid entry format: #{entry.inspect}")
      end
    end
  end

  def question_system_role
    <<~TEXT

      You are a patient and caring AI. You are here to help me understand my
      situation. I will ask you questions about the journal entries in my
      journal that you are plugged into. The question I ask will also come along
      with some context (if any is found in the journal). Use the provided
      context to answer my question. If you don't know the answer, just say so,
      especially if the context provided doesn't seem be related to the
      question.

      Don't say "Based on the context provided" or "Based on the journal entries
      provided" or anything like that.

      Don't mention "journal" or "journal entry" or anything like that.

      Just answer the question as if you were talking to a human.

      Refer to me as "you" or "your" when you answer my question.
    TEXT
  end
end
