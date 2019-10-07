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

ActiveRecord::Schema.define(version: 2019_10_04_105300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "endpoints", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "discarded_at"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["discarded_at"], name: "index_endpoints_on_discarded_at"
    t.index ["user_id", "name"], name: "index_endpoints_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_endpoints_on_user_id"
  end

  create_table "endpoints_packages", id: false, force: :cascade do |t|
    t.bigint "endpoint_id", null: false
    t.bigint "package_id", null: false
    t.index ["endpoint_id", "package_id"], name: "index_endpoints_packages_on_endpoint_id_and_package_id", unique: true
    t.index ["endpoint_id"], name: "index_endpoints_packages_on_endpoint_id"
    t.index ["package_id"], name: "index_endpoints_packages_on_package_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name", null: false
    t.string "alias"
    t.string "title"
    t.string "descr"
    t.boolean "trusted", default: false
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "discarded_at"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["discarded_at"], name: "index_packages_on_discarded_at"
    t.index ["group_id"], name: "index_packages_on_group_id"
    t.index ["user_id", "name"], name: "index_packages_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_packages_on_user_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "name", null: false
    t.string "descr"
    t.string "dest"
    t.text "script"
    t.bigint "package_id"
    t.datetime "discarded_at"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["discarded_at"], name: "index_parts_on_discarded_at"
    t.index ["package_id", "name"], name: "index_parts_on_package_id_and_name"
    t.index ["package_id"], name: "index_parts_on_package_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "locale", limit: 10
    t.boolean "trusted", default: false
    t.bigint "user_id"
    t.datetime "discarded_at"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["user_id"], name: "index_users_on_user_id"
  end

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
