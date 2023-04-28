class FetchEmbeddings
  def initialize(text_content)
    @text_content = text_content
  end

  def self.run(text_content)
    new(text_content).run
  end

  def run
    text_chunks = GenerateTextChunks.run(text_content)
    result = embeddings_from_chunks(text_chunks)
    result["data"].map do |embedding_data|
      {
        chunk_text: text_chunks[embedding_data["index"]],
        embedding: embedding_data["embedding"]
      }
    end
  end

  private

  attr_reader :text_content

  def embeddings_from_chunks(text_chunks)
    client.embeddings(
      parameters: {
        model: "text-embedding-ada-002",
        input: text_chunks
      }
    )
  end

  def client
    @client ||= OpenAI::Client.new
  end
end
