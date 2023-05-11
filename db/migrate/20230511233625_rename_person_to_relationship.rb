class RenamePersonToRelationship < ActiveRecord::Migration[7.0]
  def change
    rename_table :people, :relationships

    remove_index :journal_entries_people, name: "index_journal_entries_people_on_person_id"
    remove_index :journal_entries_people, name: "index_journal_entries_people_on_journal_entry_id"
    remove_index :journal_entries_people, name: "index_journal_entries_people_on_journal_entry_id_and_person_id"

    rename_table :journal_entries_people, :journal_entries_relationships

    change_table :journal_entries_relationships do |t|
      t.rename :person_id, :relationship_id
    end

    add_index :journal_entries_relationships,
              %i[journal_entry_id relationship_id],
              unique: true,
              name: "index_journal_entries_relationships_on_entry_and_relationship"

    add_index :journal_entries_relationships, :journal_entry_id
    add_index :journal_entries_relationships, :relationship_id

    change_table :relationship_summaries do |t|
      t.rename :person_id, :relationship_id
    end
  end
end
