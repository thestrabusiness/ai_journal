class AddEmbeddingToJournalEntry < ActiveRecord::Migration[7.0]
  def up
    enable_extension 'vector'
    create_table :embeddings do |t|
      t.text :content, null: false
      t.vector :embedding, limit: 1536
      t.references :embeddable, polymorphic: true, index: true, null: false

      t.timestamps null: false
    end
  end

  def down
    drop_table :embeddings
    disable_extension 'vector'
  end
end
