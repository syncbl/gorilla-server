class InitBaseTables < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'
    # ----------
    create_table :companies do |t|
      t.string :name

      t.datetime :blocked_at
      t.string :block_reason

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.index [:name], unique: true
    end
    # ----------
    create_table :users do |t|
      t.string :name
      t.string :locale, limit: 10
      t.boolean :trusted, default: false
      t.boolean :admin, default: false
      t.boolean :developer, default: false
      #t.boolean :group, default: false
      # TODO: Purchases table for user or company

      t.belongs_to :company, optional: true

      t.datetime :blocked_at
      t.string :block_reason

      t.datetime :discarded_at
      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.index [:discarded_at]
    end
    # ----------
    create_table :endpoints do |t|
      t.string :name
      # TODO: Store PC parameters here
      t.text :data

      t.string :key, null: false, limit: 36, default: -> { 'gen_random_uuid()' }
      t.string :authentication_token, limit: 24
      t.belongs_to :user

      t.datetime :blocked_at
      t.string :block_reason

      t.datetime :discarded_at
      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.index [:discarded_at]
      t.index [:key], unique: true
    end
    # ----------
    create_table :packages do |t|
      t.string :name, null: false
      t.string :alias, optional: true
      t.string :text
      t.string :version
      t.string :key, null: false, limit: 36, default: -> { 'gen_random_uuid()' }

      # TODO: Do we need that?
      t.string :filename
      t.string :checksum

      t.boolean :trusted, null: false, default: false

      t.belongs_to :user, optional: true
      # You can link packages one to another to chain updates
      t.belongs_to :package, optional: true

      t.datetime :discarded_at
      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      # Packages will be unique for everyone or for selected user

      t.index [:discarded_at]
      t.index [:user_id, :name], unique: true
      t.index [:alias], unique: true
      t.index [:key], unique: true
    end
    # ----------
    create_table :dependencies do |t|
      t.integer :dependent_package_id, index: true

      t.belongs_to :package

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.index [:package_id, :dependent_package_id], unique: true
    end
    # ----------
    create_table :settings do |t|
      # TODO: Logs, other data, variables and settings
      t.boolean :dependent, null: false, default: false

      t.belongs_to :endpoint
      t.belongs_to :package

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at

      t.index [:endpoint_id, :package_id], unique: true
      t.index [:discarded_at]
    end
  end
end
