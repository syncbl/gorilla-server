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

ActiveRecord::Schema.define(version: 2019_10_11_184522) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "endpoints", force: :cascade do |t|
    t.string "name"
    t.text "data"
    t.bigint "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_endpoints_on_discarded_at"
    t.index ["user_id", "name"], name: "index_endpoints_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_endpoints_on_user_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name", null: false
    t.string "alias"
    t.string "title"
    t.string "description"
    t.string "version"
    t.string "key", default: -> { "(md5(((random())::text || (clock_timestamp())::text)))::uuid" }, null: false
    t.bigint "user_id"
    t.bigint "package_id"
    t.bigint "product_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_packages_on_discarded_at"
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
    t.bigint "package_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_parts_on_discarded_at"
    t.index ["package_id", "name"], name: "index_parts_on_package_id_and_name"
    t.index ["package_id"], name: "index_parts_on_package_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "package_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_products_on_discarded_at"
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

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "locale", limit: 10
    t.boolean "trusted", default: false
    t.boolean "group", default: false
    t.bigint "user_id"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["user_id"], name: "index_users_on_user_id"
  end

  add_foreign_key "taggings", "tags"
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
