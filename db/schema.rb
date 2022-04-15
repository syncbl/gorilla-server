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

ActiveRecord::Schema[7.0].define(version: 2022_02_16_150508) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.integer "blob_id"
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["checksum"], name: "index_active_storage_blobs_on_checksum"
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.jsonb "caption_translations", null: false
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_at"], name: "index_categories_on_created_at"
    t.index ["updated_at"], name: "index_categories_on_updated_at"
  end

  create_table "dependencies", force: :cascade do |t|
    t.uuid "package_id", null: false
    t.uuid "dependent_package_id", null: false
    t.integer "category_id"
    t.boolean "optional", default: false, null: false
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["category_id"], name: "index_dependencies_on_category_id"
    t.index ["dependent_package_id"], name: "index_dependencies_on_dependent_package_id"
    t.index ["package_id", "dependent_package_id"], name: "index_dependencies_on_package_id_and_dependent_package_id", unique: true
    t.index ["package_id"], name: "index_dependencies_on_package_id"
  end

  create_table "endpoints", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.inet "remote_ip"
    t.string "locale"
    t.string "authentication_token"
    t.uuid "user_id"
    t.datetime "blocked_at", precision: nil
    t.string "block_reason"
    t.datetime "reseted_at", precision: nil
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["authentication_token"], name: "index_endpoints_on_authentication_token", unique: true
    t.index ["created_at"], name: "index_endpoints_on_created_at"
    t.index ["updated_at"], name: "index_endpoints_on_updated_at"
    t.index ["user_id"], name: "index_endpoints_on_user_id"
  end

  create_table "packages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "name", null: false
    t.string "type", null: false
    t.jsonb "caption_translations", null: false
    t.jsonb "short_description_translations", default: {"en"=>""}, null: false
    t.jsonb "description_translations", default: {"en"=>""}, null: false
    t.jsonb "params", default: {}, null: false
    t.bigint "size", default: 0, null: false
    t.bigint "settings_count", default: 0, null: false
    t.uuid "user_id", null: false
    t.boolean "private", default: true
    t.datetime "published_at", precision: nil
    t.datetime "blocked_at", precision: nil
    t.string "block_reason"
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_at"], name: "index_packages_on_created_at"
    t.index ["type"], name: "index_packages_on_type"
    t.index ["updated_at"], name: "index_packages_on_updated_at"
    t.index ["user_id", "name"], name: "index_packages_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_packages_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_at"], name: "index_plans_on_created_at"
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.uuid "package_id", null: false
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_at"], name: "index_products_on_created_at"
    t.index ["package_id"], name: "index_products_on_package_id", unique: true
    t.index ["updated_at"], name: "index_products_on_updated_at"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.jsonb "data"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_at"], name: "index_sessions_on_created_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "settings", force: :cascade do |t|
    t.uuid "endpoint_id", null: false
    t.uuid "package_id", null: false
    t.jsonb "data"
    t.boolean "consistent", default: true, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_at"], name: "index_settings_on_created_at"
    t.index ["endpoint_id", "package_id"], name: "index_settings_on_endpoint_id_and_package_id", unique: true
    t.index ["endpoint_id"], name: "index_settings_on_endpoint_id"
    t.index ["package_id"], name: "index_settings_on_package_id"
    t.index ["updated_at"], name: "index_settings_on_updated_at"
  end

  create_table "sources", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "caption_translations", default: {"en"=>""}, null: false
    t.jsonb "description_translations", default: {"en"=>""}, null: false
    t.string "version"
    t.jsonb "files", default: {}, null: false
    t.jsonb "delete_files", default: [], null: false
    t.bigint "unpacked_size", default: 0, null: false
    t.boolean "merged", default: false, null: false
    t.boolean "partial", default: false, null: false
    t.bigint "settings_count", default: 0, null: false
    t.uuid "package_id", null: false
    t.datetime "published_at", precision: nil
    t.datetime "blocked_at", precision: nil
    t.string "block_reason"
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["created_at"], name: "index_sources_on_created_at"
    t.index ["package_id"], name: "index_sources_on_package_id"
    t.index ["updated_at"], name: "index_sources_on_updated_at"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "fullname"
    t.citext "name", null: false
    t.string "locale"
    t.string "plan"
    t.string "authentication_token"
    t.datetime "blocked_at", precision: nil
    t.string "block_reason"
    t.datetime "reseted_at", precision: nil
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["created_at"], name: "index_users_on_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["plan"], name: "index_users_on_plan"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["updated_at"], name: "index_users_on_updated_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "dependencies", "categories"
  add_foreign_key "dependencies", "packages"
  add_foreign_key "dependencies", "packages", column: "dependent_package_id"
  add_foreign_key "endpoints", "users"
  add_foreign_key "packages", "users"
  add_foreign_key "plans", "users"
  add_foreign_key "products", "packages"
  add_foreign_key "settings", "endpoints"
  add_foreign_key "settings", "packages"
  add_foreign_key "sources", "packages"
end
