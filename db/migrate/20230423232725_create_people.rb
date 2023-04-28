class CreatePeople < ActiveRecord::Migration[7.0]
  def up
    create_table :people do |t|
      t.string :name, null: false, index: true
      t.timestamps
    end

    create_table :relationship_summary_embeddings do |t|
      t.text :content, null: false
      t.vector :embedding, limit: 1536
      t.references :person, null: false, foreign_key: true, index: true
      t.references :journal_entry, null: true, index: true
      t.timestamps
    end

    rename_table :embeddings, :journal_entry_embeddings

    change_table :journal_entry_embeddings do |t|
      t.references :journal_entry, foreign_key: true, index: true
      ActiveRecord::Base.connection.execute("UPDATE journal_entry_embeddings SET journal_entry_id = embeddable_id")
      t.remove :embeddable_id
      t.remove :embeddable_type
      t.change_null :journal_entry_id, false
    end

    create_table :journal_entries_people do |t|
      t.references :journal_entry, null: false, foreign_key: true, index: true
      t.references :person, null: false, foreign_key: true, index: true
      t.index %i[journal_entry_id person_id], unique: true
      t.timestamps
    end
  end

  def down
    drop_table :journal_entries_people

    change_table :journal_entry_embeddings do |t|
      t.references :embeddable, polymorphic: true, index: true
      ActiveRecord::Base.connection.execute("UPDATE journal_entry_embeddings SET embeddable_id = journal_entry_id, embeddable_type = 'JournalEntry'")
      t.change_null :embeddable_id, false
      t.change_null :embeddable_type, false
      t.remove :journal_entry_id
    end

    rename_table :journal_entry_embeddings, :embeddings

    drop_table :relationship_summary_embeddings
    drop_table :people
  end
end
