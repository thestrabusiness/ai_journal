class RemoveContentColumnFromJournalEntries < ActiveRecord::Migration[7.0]
  def change
    remove_column :journal_entries, :content
  end
end
