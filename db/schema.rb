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
  enable_extension "plpgsql"

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "endpoints", force: :cascade do |t|
    t.string "name"
    t.text "data"
    t.string "key", default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.bigint "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_endpoints_on_discarded_at"
    t.index ["key"], name: "index_endpoints_on_key"
    t.index ["user_id", "name"], name: "index_endpoints_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_endpoints_on_user_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name", null: false
    t.string "alias"
    t.string "title"
    t.string "text"
    t.string "version"
    t.string "key", default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.string "tags", default: "", null: false
    t.boolean "published", default: false, null: false
    t.boolean "unstable", default: false, null: false
    t.bigint "user_id"
    t.bigint "package_id"
    t.bigint "product_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_packages_on_discarded_at"
    t.index ["key"], name: "index_packages_on_key"
    t.index ["package_id"], name: "index_packages_on_package_id"
    t.index ["product_id"], name: "index_packages_on_product_id"
    t.index ["user_id", "name"], name: "index_packages_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_packages_on_user_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "destination"
    t.text "script"
    t.string "key", default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.bigint "package_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_parts_on_discarded_at"
    t.index ["key"], name: "index_parts_on_key"
    t.index ["package_id", "name"], name: "index_parts_on_package_id_and_name"
    t.index ["package_id"], name: "index_parts_on_package_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title", null: false
    t.text "text"
    t.string "key", default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.boolean "approved", default: false, null: false
    t.bigint "package_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_products_on_discarded_at"
    t.index ["key"], name: "index_products_on_key"
    t.index ["package_id"], name: "index_products_on_package_id"
  end

  create_table "requirements", force: :cascade do |t|
    t.bigint "package_id"
    t.integer "required_package_id"
    t.index ["package_id", "required_package_id"], name: "index_requirements_on_package_id_and_required_package_id", unique: true
    t.index ["package_id"], name: "index_requirements_on_package_id"
    t.index ["required_package_id"], name: "index_requirements_on_required_package_id"
  end

  create_table "settings", force: :cascade do |t|
    t.text "data"
    t.text "log"
    t.bigint "endpoint_id"
    t.bigint "package_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_settings_on_discarded_at"
    t.index ["endpoint_id", "package_id"], name: "index_settings_on_endpoint_id_and_package_id", unique: true
    t.index ["endpoint_id"], name: "index_settings_on_endpoint_id"
    t.index ["package_id"], name: "index_settings_on_package_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "locale", limit: 10
    t.bigint "user_id"
    t.string "authentication_token", limit: 30
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "discarded_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["authentication_token"], name: "index_users_on_authentication_token"
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_id"], name: "index_users_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.endpoints_before_update_row_tr()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER endpoints_before_update_row_tr BEFORE UPDATE ON \"endpoints\" FOR EACH ROW EXECUTE PROCEDURE endpoints_before_update_row_tr()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.packages_before_update_row_tr()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER packages_before_update_row_tr BEFORE UPDATE ON \"packages\" FOR EACH ROW EXECUTE PROCEDURE packages_before_update_row_tr()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.parts_before_update_row_tr()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER parts_before_update_row_tr BEFORE UPDATE ON \"parts\" FOR EACH ROW EXECUTE PROCEDURE parts_before_update_row_tr()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.users_before_update_row_tr()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER users_before_update_row_tr BEFORE UPDATE ON \"users\" FOR EACH ROW EXECUTE PROCEDURE users_before_update_row_tr()")

end
