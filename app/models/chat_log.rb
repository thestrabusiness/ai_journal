class ChatLog < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
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
    new_assistant_response = FetchChatCompletion.run(
      conversation_entries_for_assistant_request,
      model: model_for_kind
    )
    add_assistant_response(new_assistant_response)
  end

  def model_for_kind
    question? ? FetchChatCompletion::Models::GPT_4_TURBO_PREVIEW : FetchChatCompletion::Models::GPT_3_5_TURBO
  end

  def init_system_role
    if question?
      add_entry("system", question_system_role)
    else
      add_entry("system", chat_system_role)
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

  def chat_system_role
    <<~TEXT

      You are a helpful assistant that helps people discover themselves more
      deeply and work through personal challenges. You don’t tell people what to
      do, but enable them to find their own solutions by reflecting their input
      back to themselves

      Ask me a questions that enable me to dig deeper into my situation.

      Please end all of your responses with follow up questions that help me dig
      deeper. Also, keep your responses shorter. I want this to be more of a
      back-and-forth conversation that helps me get to the right answer on my
      own, instead of a conversation where you’re just suggesting solutions.

      When I respond to these questions, reflect my answers back to me and ask
      me follow up questions to help me with self discovery.

      Don't use imperative language. Make suggestions and ask questions.

      Open the conversation with a question to get me talking about my
      situation.

    TEXT
  end
end
