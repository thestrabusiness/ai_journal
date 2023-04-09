class CreateJournalEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :journal_entries do |t|
      t.text :content
      t.string :title

      t.timestamps
    end
  end
end
