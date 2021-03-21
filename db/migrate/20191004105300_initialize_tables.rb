class InitializeTables < ActiveRecord::Migration[6.0]
  def change
    enable_extension "pgcrypto"
    enable_extension "hstore"
    enable_extension "citext"

    # ----------
    create_table :users, id: :uuid do |t|
      t.string :name

      t.citext :username, index: true, null: false, unique: true
      t.string :locale

      #t.boolean :trusted, default: false
      #t.boolean :admin, default: false
      #t.boolean :developer, default: false
      # TODO: Purchases table for user or company

      t.string :authentication_token, null: false, unique: true

      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    # ----------
    create_table :subscriptions, id: false do |t|
      t.belongs_to :user, type: :uuid, index: true, null: false, foreign_key: true
      t.belongs_to :subscribed_to, class_name: "User", type: :uuid, index: true, null: false
      t.datetime :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.index %i[user_id subscribed_to_id], unique: true
    end

    # ----------
    create_table :endpoints, id: :uuid do |t|
      t.string :name
      t.inet :remote_ip
      t.string :locale

      # TODO: Store PC parameters here

      t.string :authentication_token, null: false, unique: true

      t.belongs_to :user, type: :uuid, foreign_key: true, index: true, null: false

      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    # ----------
    create_table :packages, id: :uuid do |t|
      t.citext :name, null: false
      t.string :destination, null: false, default: ""

      # TODO: Check size by HEAD for external URLs
      t.bigint :size, null: false, default: 0
      t.string :external_url

      # Show this package to everyone?
      t.belongs_to :published_by, class_name: "User", type: :uuid, index: true
      t.boolean :is_component, null: false, default: false
      t.jsonb :data

      t.belongs_to :user, type: :uuid, index: true, null: false, foreign_key: true
      t.belongs_to :replacement, type: :uuid, index: true, foreign_key: { to_table: :packages }

      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }

      # Packages will be unique for everyone or for selected user

      t.index %i[user_id name], unique: true
    end

    # ----------
    create_table :dependencies, id: false do |t|
      t.belongs_to :package, type: :uuid, index: true, null: false, foreign_key: true
      t.belongs_to :dependent_package, class_name: "Package", type: :uuid, index: true, null: false

      t.datetime :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.index %i[package_id dependent_package_id], unique: true
    end

    # ----------
    create_table :settings do |t|
      # TODO: Logs, other data, variables and settings

      # TODO: Route for update
      t.belongs_to :endpoint, type: :uuid, index: true, null: false, foreign_key: true
      t.belongs_to :package, type: :uuid, index: true, null: false, foreign_key: true

      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[endpoint_id package_id], unique: true
    end

    # ----------
    create_table :sources, id: :uuid do |t|
      # TODO: What to do with file: run, unpack, exec
      t.string :description, null: false, default: ""
      t.string :version
      t.jsonb :filelist
      t.bigint :unpacked_size, null: false, default: 0
      t.boolean :is_merged, null: false, default: false

      t.belongs_to :package, type: :uuid, index: true, null: false, foreign_key: true

      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
