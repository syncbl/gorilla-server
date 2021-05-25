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
      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at
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
      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at
    end

    # ----------
    create_table :packages, id: :uuid do |t|
      t.citext :name, null: false

      # TODO: Multilanguage support for title and description
      #t.string :title, null: false

      t.string :destination, null: false, default: ""

      t.string :description

      t.bigint :size, null: false, default: 0
      t.bigint :settings_count, null: false, default: 0

      t.string :external_url
      t.string :mime_type

      # TODO: Components will be removed after parent package delete
      t.boolean :is_component, null: false, default: false
      t.boolean :is_optional, null: false, default: false
      # Persistent packages excluded from autoupdate, CAN'T BE CHANGED
      #t.boolean :is_persistent, null: false, default: false

      # TODO: Copyrignt and else in t.jsonb :data

      t.references :user, type: :uuid, index: true, null: false,
                          foreign_key: true
      t.references :replacement, type: :uuid, index: true,
                                 foreign_key: { to_table: :packages }

      t.datetime :validated_at
      t.datetime :published_at
      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at

      # Packages will be unique for everyone or for selected user

      t.index %i[user_id name], unique: true
    end

    # ----------
    create_table :dependencies, id: false do |t|
      t.references :package, type: :uuid, index: true, null: false,
                             foreign_key: true
      t.references :component, type: :uuid, index: true, null: false,
                               foreign_key: { to_table: :packages }
      t.datetime :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.index %i[package_id component_id], unique: true
    end

    # ----------
    create_table :sources, id: :uuid do |t|
      # TODO: What to do with file: run, unpack, exec
      t.string :description
      t.string :version
      t.jsonb :filelist
      t.integer :file_count, null: false, default: 0
      t.bigint :unpacked_size, null: false, default: 0
      t.boolean :is_merged, null: false, default: false
      t.datetime :published_at
      t.bigint :settings_count, null: false, default: 0

      # TODO: Posibility to add external link
      # Source becomes unsafe!
      #t.string :external_url
      #t.string :mime_type
      #t.bigint :size

      t.references :package, type: :uuid, index: true, null: false, foreign_key: true

      t.datetime :validated_at
      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at
    end

    # ----------
    create_table :settings do |t|
      # TODO: Logs, other data, variables and settings

      t.references :endpoint, type: :uuid, index: true, null: false, foreign_key: true
      t.references :package, type: :uuid, index: true, null: false, foreign_key: true
      t.references :source, type: :uuid, index: true, foreign_key: true

      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at

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
      t.datetime :updated_at
    end

    # ----------
    create_table :subscriptions do |t|
      t.references :user, type: :uuid, index: true, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
