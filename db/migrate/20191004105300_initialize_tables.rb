class InitializeTables < ActiveRecord::Migration[6.0]
  def change
    enable_extension "pgcrypto"
    enable_extension "citext"

    # ----------
    create_table :users, id: :uuid do |t|
      t.string :fullname

      t.citext :name, null: false, index: true, unique: true
      t.string :locale
      t.string :plan, index: true

      #t.boolean :trusted, default: false
      #t.boolean :admin, default: false
      #t.boolean :developer, default: false
      # TODO: Purchases table for user or company

      # TODO: Is company? Show other info.

      t.string :authentication_token, null: false, index: true, unique: true

      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    # ----------
    create_table :endpoints, id: :uuid do |t|
      t.string :name
      t.inet :remote_ip
      t.string :locale

      # TODO: Store PC parameters here

      t.string :authentication_token, null: false, index: true, unique: true

      t.references :user, type: :uuid, index: true, foreign_key: true

      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    # ----------
    create_table :packages, id: :uuid do |t|
      t.citext :name, null: false
      t.string :package_type, index: true

      t.jsonb :caption_translations, null: false
      t.jsonb :description_translations

      t.jsonb :data

      # TODO: Move path to data
      t.string :default_path, null: false, default: ""
      t.boolean :path_changeable, null: false, default: true

      t.bigint :size, null: false, default: 0
      t.bigint :settings_count, null: false, default: 0

      # TODO: Components will be removed after parent package delete
      t.boolean :is_component, null: false, default: false
      t.string :external_url
      t.string :mime_type

      # TODO: Copyrignt and else in t.jsonb :data

      t.references :user, type: :uuid, index: true, null: false,
                          foreign_key: true
      t.references :replacement, type: :uuid, index: true,
                                 foreign_key: { to_table: :packages }

      t.datetime :validated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :published_at
      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[user_id name], unique: true
    end

    # ----------
    create_table :dependencies, id: false do |t|
      t.references :package, type: :uuid, index: true, null: false,
                             foreign_key: true
      t.references :dependent_package, type: :uuid, index: true, null: false,
                               foreign_key: { to_table: :packages }
      t.boolean :is_optional, null: false, default: false
      t.datetime :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.index %i[package_id dependent_package_id], unique: true
    end

    # ----------
    create_table :sources, id: :uuid do |t|
      # TODO: What to do with file: run, unpack, exec
      t.jsonb :description_translations
      t.string :version
      t.jsonb :filelist
      t.integer :file_count, null: false, default: 0
      t.bigint :unpacked_size, null: false, default: 0
      t.boolean :is_merged, null: false, default: false
      t.datetime :published_at
      t.bigint :settings_count, null: false, default: 0

      t.references :package, type: :uuid, index: true, null: false, foreign_key: true

      t.datetime :validated_at
      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    # ----------
    create_table :settings, id: false do |t|
      # TODO: Logs, other data, variables and settings

      t.references :endpoint, type: :uuid, index: true, null: false, foreign_key: true
      t.references :package, type: :uuid, index: true, null: false, foreign_key: true
      t.references :source, type: :uuid, index: true, foreign_key: true

      t.jsonb :data

      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[endpoint_id package_id], unique: true
    end

    # ----------
    create_table :maintains, id: false do |t|
      t.references :package, type: :uuid, index: true, null: false, foreign_key: true
      t.references :user, type: :uuid, index: true, null: false, foreign_key: true

      t.datetime :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.index %i[package_id user_id], unique: true
    end

    # ----------
    create_table :products do |t|
      t.references :package, type: :uuid, index: true, unique: true, null: false, foreign_key: true

      # Price, license, etc.
      t.datetime :validated_at
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    # ----------
    create_table :subscriptions do |t|
      t.references :user, type: :uuid, index: true, null: false, foreign_key: true

      # Payment info

      t.datetime :start_time
      t.datetime :end_time
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
