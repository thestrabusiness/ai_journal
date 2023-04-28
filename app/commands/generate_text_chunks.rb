class GenerateTextChunks
  # Constants
  CHUNK_SIZE = 1024 # The target size of each text chunk in tokens
  MIN_CHUNK_SIZE_CHARS = 350 # The minimum size of each text chunk in characters
  MIN_CHUNK_LENGTH_TO_EMBED = 5 # Discard chunks shorter than this
  EMBEDDINGS_BATCH_SIZE = 128 # The number of embeddings to request at a time
  MAX_NUM_CHUNKS = 10_000 # The maximum number of chunks to generate from a text

  def initialize(text, chunk_size:)
    @text = text
    @chunk_size = chunk_size
  end

  def self.run(text, chunk_size: CHUNK_SIZE)
    new(text, chunk_size:).run
  end

  def run
    # Return an empty list if the text is empty or whitespace
    return [] if text.nil? || text.strip.empty?

    # If the text is shorter than the minimum chunk size, just return the text
    return [text] if text.size < MIN_CHUNK_SIZE_CHARS

    # Tokenize the text
    tokens = tokenizer.encode(text)

    # Initialize an empty list of chunks
    chunks = []

    # Initialize a counter for the number of chunks
    number_of_chunks = 0

    while !tokens.empty? && number_of_chunks < MAX_NUM_CHUNKS
      # Take the first chunk_size tokens as a chunk
      chunk = tokens.take(chunk_size)

      # Decode the chunk into text
      chunk_text = tokenizer.decode(chunk)

      # Skip the chunk if it is empty or whitespace
      if chunk_text.nil? || chunk_text.strip.empty?
        tokens = tokens.drop(chunk.size)
        next
      end

      # Find the last period or punctuation mark in the chunk
      last_punctuation = [
        chunk_text.rindex("."),
        chunk_text.rindex("?"),
        chunk_text.rindex("!"),
        chunk_text.rindex("\n")
      ].compact.max

      # If there is a punctuation mark, and the last punctuation index is before MIN_CHUNK_SIZE_CHARS
      if last_punctuation && last_punctuation > MIN_CHUNK_SIZE_CHARS
        # Truncate the chunk text at the punctuation mark
        chunk_text = chunk_text[0..last_punctuation]
      end

      # Remove any newline characters and strip any leading or trailing whitespace
      chunk_text_to_append = chunk_text.gsub("\n", " ").strip

      if chunk_text_to_append.size > MIN_CHUNK_LENGTH_TO_EMBED
        # Append the chunk text to the list of chunks
        chunks << chunk_text_to_append
      end

      # Remove the tokens corresponding to the chunk text from the remaining tokens
      tokens = tokens.drop(tokenizer.encode(chunk_text).size)

      # Increment the number of chunks
      number_of_chunks += 1
    end

    # Handle the remaining tokens
    unless tokens.empty?
      remaining_text = tokenizer.decode(tokens).gsub("\n", " ").strip
      if remaining_text.size > MIN_CHUNK_LENGTH_TO_EMBED
        chunks << remaining_text
      end
    end

    chunks
  end

  def tokenizer
    @tokenizer ||= Tiktoken.get_encoding("cl100k_base")
  end

  private

  attr_reader :chunk_size, :text
end
