class InitializeTables < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'
    # ----------
    create_table :users, id: :uuid do |t|
      t.string :name, limit: 100
      t.string :locale, limit: 10
      t.boolean :trusted, default: false
      t.boolean :admin, default: false
      t.boolean :developer, default: false
      # TODO: Purchases table for user or company

      t.string :authentication_token, limit: 24

      t.string :discard_reason
      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end
    # ----------
    create_table :endpoints, id: :uuid do |t|
      t.string :name, limit: 100
      # TODO: Store PC parameters here

      t.string :authentication_token, limit: 24

      t.belongs_to :user, type: :uuid, foreign_key: true, index: true, null: false

      t.string :discard_reason
      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end
    # ----------
    create_table :packages, id: :uuid do |t|
      t.string :name, limit: 100, null: false
      t.string :alias, limit: 100

      t.boolean :trusted, null: false, default: false

      t.jsonb :data

      t.belongs_to :user, type: :uuid, foreign_key: true, index: true, null: false
      # You can link packages one to another to chain updates
      t.belongs_to :package, type: :uuid, foreign_key: true, index: true

      t.datetime :discarded_at, index: true
      t.datetime :created_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      # Packages will be unique for everyone or for selected user

      t.index [:alias], unique: true
      t.index [:user_id, :name], unique: true
    end
    # ----------
    create_table :dependencies, id: false do |t|
      t.belongs_to :package, type: :uuid, foreign_key: true, index: true, null: false
      t.belongs_to :dependent_package, class_name: 'Package', type: :uuid, index: true, null: false

      # TODO: Some of the dependencies can be selected by user before master package installation
      t.boolean :optional, null: false, default: false

      t.index [:package_id, :dependent_package_id], unique: true
    end
    # ----------
    # TODO: id?
    # ----------
    create_table :settings do |t|
      # TODO: Logs, other data, variables and settings
      t.boolean :dependent, null: false, default: false

      t.belongs_to :endpoint, type: :uuid, foreign_key: true, index: true, null: false
      t.belongs_to :package, type: :uuid, foreign_key: true, index: true, null: false

      t.datetime :created_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, index: true, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at, index: true

      t.index [:endpoint_id, :package_id], unique: true
    end
  end
end
