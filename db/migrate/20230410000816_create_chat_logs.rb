class CreateChatLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_logs do |t|
      t.jsonb :conversation_entries, null: false, default: []
      t.references :journal_entry, null: true, foreign_key: true, index: true

      t.timestamps
    end
  end
end
