class AddAnalysisToJournalEntry < ActiveRecord::Migration[7.0]
  def change
    add_column :journal_entries, :analysis, :text
  end
end
