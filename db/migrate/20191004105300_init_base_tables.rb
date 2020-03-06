class InitBaseTables < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'
    # ----------
    create_table :companies do |t|
      t.string :name, index: true

      t.datetime :blocked_at
      t.string :block_reason

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at, index: true
    end
    # ----------
    create_table :users do |t|
      t.string :name
      t.string :locale, limit: 10
      t.boolean :trusted, default: false
      t.boolean :admin, default: false
      t.boolean :developer, default: false
      #t.boolean :group, default: false

      t.belongs_to :company, index: true, optional: true

      t.datetime :blocked_at
      t.string :block_reason

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at, index: true
    end
    # ----------
    create_table :endpoints do |t|
      t.string :name
      # TODO: Store PC parameters here
      t.text :data

      t.string :key, index: true, null: false, limit: 36, default: -> { 'gen_random_uuid()' }
      t.string :authentication_token, unique: true, limit: 24
      t.belongs_to :user, index: true

      t.datetime :blocked_at
      t.string :block_reason

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at, index: true
      # To make computers individual
      #t.index [:user_id, :name], unique: true # ...
    end
    # ----------
    create_table :packages do |t|
      t.string :name, null: false
      t.string :alias, index: true, optional: true
      t.string :text
      t.string :version
      t.string :key, index: true, null: false, limit: 36, default: -> { 'gen_random_uuid()' }
      t.string :filename
      t.string :checksum

      t.boolean :trusted, null: false, default: false

      t.belongs_to :user, index: true, optional: true
      # You can link packages one to another to chain updates
      t.belongs_to :package, index: true, optional: true

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at, index: true
      # Packages will be unique for everyone or for selected user
      t.index [:user_id, :name], unique: true
    end
    # ----------
    create_table :dependencies do |t|
      t.integer :dependent_package_id, index: true

      t.belongs_to :package

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at, index: true
      t.index [:package_id, :dependent_package_id], unique: true
    end
    # ----------
    create_table :settings do |t|
      # TODO: Purchase information, logs, other data, variables and settings
      t.boolean :dependent, null: false, default: false

      t.belongs_to :endpoint
      t.belongs_to :package

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :installed_at
      t.datetime :discarded_at, index: true
      t.index [:endpoint_id, :package_id], unique: true
    end
  end
end
