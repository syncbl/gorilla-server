class InitializeTables < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'

    # ----------
    create_table :users, id: :uuid do |t|
      t.string :name, limit: 100

      t.string :username, limit: 39, index: true, null: false
      t.string :locale, limit: 10

      #t.boolean :trusted, default: false
      #t.boolean :admin, default: false
      #t.boolean :developer, default: false
      # TODO: Purchases table for user or company

      t.string :authentication_token, limit: 24

      #t.string :secret, limit: 24, default: { 'substr(md5(random()::text), 0, 24)' }, null: false

      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :created_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end

    # ----------
    create_table :endpoints, id: :uuid do |t|
      t.string :name, limit: 100

      # TODO: Store PC parameters here

      t.string :authentication_token, limit: 24

      t.belongs_to :user, type: :uuid, foreign_key: true, index: true, null: false

      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :created_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end

    # ----------
    create_table :packages, id: :uuid do |t|
      t.string :name, limit: 100, null: false
      t.string :alias, limit: 100

      # TODO: Groups
      t.string :group_name, limit: 100
      # TODO: Check size by HEAD for external URLs
      t.bigint :size, null: false, default: 0
      t.string :external_url

      t.boolean :trusted, null: false, default: false

      t.jsonb :data

      t.belongs_to :user, type: :uuid, index: true, null: false, foreign_key: true
      t.belongs_to :replacement, type: :uuid, index: true, foreign_key: { to_table: :packages }

      t.datetime :blocked_at
      t.string :block_reason
      t.datetime :created_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      # Packages will be unique for everyone or for selected user

      t.index [:alias], unique: true
      t.index %i[user_id group_name]
      t.index %i[user_id name], unique: true
    end

    # ----------
    create_table :dependencies, id: false do |t|
      t.belongs_to :package, type: :uuid, index: true, null: false, foreign_key: true
      t.belongs_to :dependent_package, class_name: 'Package', type: :uuid, index: true, null: false

      t.index %i[package_id dependent_package_id], unique: true
    end

    # ----------
    create_table :settings do |t|
      # TODO: Logs, other data, variables and settings
      t.boolean :dependent, null: false, default: false

      # TODO: Route for update
      t.belongs_to :endpoint, type: :uuid, index: true, null: false, foreign_key: true
      t.belongs_to :package, type: :uuid, index: true, null: false, foreign_key: true

      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.index %i[endpoint_id package_id], unique: true
    end

    # ----------
    create_table :sources, id: :uuid do |t|
      # TODO: What to do with file: run, unpack, exec
      t.string :destination, null: false, default: ""
      t.string :description, null: false, default: ""
      t.jsonb :manifest, null: false, default: {}

      t.belongs_to :package, type: :uuid, index: true, null: false, foreign_key: true

      t.datetime :created_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
