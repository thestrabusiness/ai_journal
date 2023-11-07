class FetchChatCompletion
  class Models
    GPT_3_5_TURBO = "gpt-3.5-turbo-1106".freeze
    GPT_4 = "gpt-4".freeze
    GPT_4_TURBO_PREVIEW = "gpt-4-1106-preview".freeze
  end

  RESPONSE_TYPES = %w[text json_object].freeze

  def initialize(current_conversation, model:, response_type:)
    @current_conversation = current_conversation
    @model = model
    @response_type = response_type

    return if RESPONSE_TYPES.include?(response_type)

    raise ArgumentError, "Invalid response type, must be one of #{RESPONSE_TYPES}"
  end

  def self.run(current_conversation, model: Models::GPT_3_5_TURBO, response_type: "text")
    new(current_conversation, model:, response_type:).run
  end

  def run
    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        model:,
        messages: current_conversation,
        temperature: 0.7,
        response_format: { type: response_type }
      }
    )

    response.dig("choices", 0, "message", "content")
  end

  private

  attr_reader :current_conversation, :model, :response_type
end
