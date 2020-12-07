# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_19_005009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "dependencies", id: false, force: :cascade do |t|
    t.uuid "package_id", null: false
    t.uuid "dependent_package_id", null: false
    t.index ["dependent_package_id"], name: "index_dependencies_on_dependent_package_id"
    t.index ["package_id", "dependent_package_id"], name: "index_dependencies_on_package_id_and_dependent_package_id", unique: true
    t.index ["package_id"], name: "index_dependencies_on_package_id"
  end

  create_table "endpoints", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", limit: 100
    t.string "authentication_token", limit: 24
    t.uuid "user_id", null: false
    t.datetime "blocked_at"
    t.string "block_reason"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_at"], name: "index_endpoints_on_created_at"
    t.index ["updated_at"], name: "index_endpoints_on_updated_at"
    t.index ["user_id"], name: "index_endpoints_on_user_id"
  end

  create_table "packages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "alias", limit: 100
    t.string "group_name", limit: 100
    t.bigint "size", default: 0, null: false
    t.boolean "trusted", default: false, null: false
    t.jsonb "data"
    t.uuid "user_id", null: false
    t.uuid "replacement_id"
    t.datetime "blocked_at"
    t.string "block_reason"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["alias"], name: "index_packages_on_alias", unique: true
    t.index ["created_at"], name: "index_packages_on_created_at"
    t.index ["replacement_id"], name: "index_packages_on_replacement_id"
    t.index ["updated_at"], name: "index_packages_on_updated_at"
    t.index ["user_id", "group_name"], name: "index_packages_on_user_id_and_group_name"
    t.index ["user_id", "name"], name: "index_packages_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_packages_on_user_id"
  end

  create_table "settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "dependent", default: false, null: false
    t.uuid "endpoint_id", null: false
    t.uuid "package_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_at"], name: "index_settings_on_created_at"
    t.index ["discarded_at"], name: "index_settings_on_discarded_at"
    t.index ["endpoint_id", "package_id"], name: "index_settings_on_endpoint_id_and_package_id", unique: true
    t.index ["endpoint_id"], name: "index_settings_on_endpoint_id"
    t.index ["package_id"], name: "index_settings_on_package_id"
    t.index ["updated_at"], name: "index_settings_on_updated_at"
  end

  create_table "sources", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "destination"
    t.string "description"
    t.string "external_url"
    t.uuid "package_id", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_at"], name: "index_sources_on_created_at"
    t.index ["package_id"], name: "index_sources_on_package_id"
    t.index ["updated_at"], name: "index_sources_on_updated_at"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", limit: 100
    t.string "username", limit: 39
    t.string "locale", limit: 10
    t.string "authentication_token", limit: 24
    t.datetime "blocked_at"
    t.string "block_reason"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["created_at"], name: "index_users_on_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["updated_at"], name: "index_users_on_updated_at"
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "dependencies", "packages"
  add_foreign_key "endpoints", "users"
  add_foreign_key "packages", "packages", column: "replacement_id"
  add_foreign_key "packages", "users"
  add_foreign_key "settings", "endpoints"
  add_foreign_key "settings", "packages"
  add_foreign_key "sources", "packages"
end
