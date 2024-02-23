class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :email, null: false
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
    end

    add_index :users, :email
    add_index :users, :confirmation_token, unique: true
    add_index :users, :remember_token, unique: true

    reversible do |dir|
      dir.up do
        User.create!(
          email: Rails.application.credentials.init_email,
          password: Rails.application.credentials.init_password
        )
      end
    end

    add_reference :chat_logs, :user
    add_reference :core_values, :user
    add_reference :journal_entries, :user
    add_reference :pulse_checks, :user
    add_reference :relationships, :user

    reversible do |dir|
      dir.up do
        ChatLog.update_all(user_id: User.first.id)
        CoreValue.update_all(user_id: User.first.id)
        JournalEntry.update_all(user_id: User.first.id)
        PulseCheck.update_all(user_id: User.first.id)
        Relationship.update_all(user_id: User.first.id)
      end
    end

    add_foreign_key :chat_logs, :users
    add_foreign_key :core_values, :users
    add_foreign_key :journal_entries, :users
    add_foreign_key :pulse_checks, :users
    add_foreign_key :relationships, :users

    change_column_null :chat_logs, :user_id, false
    change_column_null :core_values, :user_id, false
    change_column_null :journal_entries, :user_id, false
    change_column_null :pulse_checks, :user_id, false
    change_column_null :relationships, :user_id, false

    remove_reference :chat_logs, :journal_entry
  end
end
