class FetchChatCompletion
  class Models
    GPT_4 = "gpt-4".freeze
    GPT_4_TURBO = "gpt-4-turbo".freeze
    GPT_4_O_MINI = "gpt-4o-mini".freeze
  end

  RESPONSE_TYPES = %w[text json_object].freeze

  def initialize(current_conversation, model:, response_type:)
    @current_conversation = current_conversation
    @model = model
    @response_type = response_type

    return if RESPONSE_TYPES.include?(response_type)

    unless Models.constants.map { |c| Models.const_get(c) }.include?(model)
      Rails.logger.warn "Invalid model, must be one of #{Models.constants.map { |c| Models.const_get(c) }}"
      Rails.logger.warn "Defaulting to #{Models::GPT_4_O_MINI}"
      @model = Models::GPT_4_O_MINI
    end

    raise ArgumentError, "Invalid response type, must be one of #{RESPONSE_TYPES}"
  end

  def self.run(current_conversation, model: Models::GPT_4_O_MINI, response_type: "text")
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
