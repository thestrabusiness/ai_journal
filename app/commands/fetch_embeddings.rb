class FetchEmbeddings
  def initialize(text_content)
    @text_content = text_content
  end

  def self.run(text_content)
    new(text_content).run
  end

  def run
    client = OpenAI::Client.new
    text_chunks = GenerateTextChunks.run(text_content)
    result = client.embeddings(
      parameters: {
        model: 'text-embedding-ada-002',
        input: text_chunks
      }
    )

    result['data'].map do |embedding_data|
      {
        chunk_text: text_chunks[embedding_data['index']],
        embedding: embedding_data['embedding']
      }
    end
  end

  private

  attr_reader :text_content
end
