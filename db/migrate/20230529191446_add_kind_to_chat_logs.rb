class AddKindToChatLogs < ActiveRecord::Migration[7.0]
  def change
    create_enum :chat_log_kinds, %w[chat question]
    add_column :chat_logs,
               :kind,
               :chat_log_kinds,
               null: false,
               index: true,
               default: "chat"
  end
end
