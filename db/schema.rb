# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_02_23_020105) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "vector"

  create_enum :chat_log_kinds, [
    "chat",
    "question",
  ], force: :cascade

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "chat_logs", force: :cascade do |t|
    t.jsonb "conversation_entries", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "kind", default: "chat", null: false, enum_type: "chat_log_kinds"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_chat_logs_on_user_id"
  end

  create_table "core_values", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_core_values_on_user_id"
  end

  create_table "journal_entries", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "analysis"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_journal_entries_on_user_id"
  end

  create_table "journal_entries_relationships", force: :cascade do |t|
    t.bigint "journal_entry_id", null: false
    t.bigint "relationship_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["journal_entry_id", "relationship_id"], name: "index_journal_entries_relationships_on_entry_and_relationship", unique: true
    t.index ["journal_entry_id"], name: "index_journal_entries_relationships_on_journal_entry_id"
    t.index ["relationship_id"], name: "index_journal_entries_relationships_on_relationship_id"
  end

  create_table "journal_entry_embeddings", force: :cascade do |t|
    t.text "content", null: false
    t.vector "embedding", limit: 1536
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "journal_entry_id", null: false
    t.index ["journal_entry_id"], name: "index_journal_entry_embeddings_on_journal_entry_id"
  end

  create_table "pulse_checks", force: :cascade do |t|
    t.text "summary"
    t.jsonb "core_value_scores", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_pulse_checks_on_user_id"
  end

  create_table "relationship_summaries", force: :cascade do |t|
    t.vector "embedding", limit: 1536
    t.bigint "relationship_id", null: false
    t.bigint "journal_entry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["journal_entry_id"], name: "index_relationship_summaries_on_journal_entry_id"
    t.index ["relationship_id"], name: "index_relationship_summaries_on_relationship_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["name"], name: "index_relationships_on_name"
    t.index ["user_id"], name: "index_relationships_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chat_logs", "users"
  add_foreign_key "core_values", "users"
  add_foreign_key "journal_entries", "users"
  add_foreign_key "journal_entries_relationships", "journal_entries"
  add_foreign_key "journal_entries_relationships", "relationships"
  add_foreign_key "journal_entry_embeddings", "journal_entries"
  add_foreign_key "pulse_checks", "users"
  add_foreign_key "relationship_summaries", "relationships"
  add_foreign_key "relationships", "users"
end
