class InitBaseTables < ActiveRecord::Migration[6.0]
  def change
    # ----------
    create_table :users do |t|
      t.string :username, unique: true, null: false
      t.string :locale, limit: 10
      t.boolean :trusted, default: false

      t.belongs_to :user, index: true, optional: true

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at
      t.index :discarded_at
    end
    create_trigger(compatibility: 1).on(:users).before(:update) do
      'NEW.updated_at = NOW();'
    end
    # ----------
    create_table :endpoints do |t|
      t.string :name

      t.belongs_to :user, index: true, optional: true

      # TODO: Store PC settings here

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at
      t.index :discarded_at
      # To make computers individual
      t.index [:user_id, :name], unique: true # ...
    end
    create_trigger(compatibility: 1).on(:endpoints).before(:update) do
      'NEW.updated_at = NOW();'
    end
    # ----------
    create_table :packages do |t|
      t.string :name, null: false
      t.string :alias, unique: true
      t.string :title
      t.string :description

      # TODO: Change to tags
      t.boolean :published, default: false # TODO: Sign or tag
      t.boolean :trusted, default: false # TODO: Digital sign by admin
      t.boolean :optional, default: false # TODO: Sign or tag

      t.belongs_to :user, index: true, optional: true
      t.belongs_to :group, index: true, optional: true

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at
      t.index :discarded_at
      # Packages will be unique for everyone or for selected user
      t.index [:user_id, :name], unique: true
    end
    create_trigger(compatibility: 1).on(:packages).before(:update) do
      'NEW.updated_at = NOW();'
    end
    # ----------
    create_join_table :endpoints, :packages do |t|
      t.index :endpoint_id
      t.index :package_id
      t.index [:endpoint_id, :package_id], unique: true
    end
    # ----------
    create_table :parts do |t|
      t.string :name, null: false
      t.string :description
      t.string :destination
      t.text :script # TODO: Encode script with user's key

      t.belongs_to :package, index: true

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at
      t.index :discarded_at
      t.index [:package_id, :name]
    end
    create_trigger(compatibility: 1).on(:parts).before(:update) do
      'NEW.updated_at = NOW();'
    end
  end
end
