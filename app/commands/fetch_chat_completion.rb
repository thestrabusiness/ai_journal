class FetchChatCompletion
  class Models
    GPT_3_5_TURBO = 'gpt-3.5-turbo'
    GPT_3_5_TURBO_0301 = 'gpt-3.5-turbo-0301'
  end

  def initialize(current_conversation, model: Models::GPT_3_5_TURBO)
    @current_conversation = current_conversation
    @model = model
  end

  def self.run(current_conversation)
    new(current_conversation).run
  end

  def run
    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        model:,
        messages: current_conversation,
        temperature: 0.7
      }
    )

    response.dig('choices', 0, 'message', 'content')
  end

  private

  attr_reader :current_conversation, :model
end
