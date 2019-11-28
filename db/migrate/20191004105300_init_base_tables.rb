class InitBaseTables < ActiveRecord::Migration[6.0]
  def change
    # ----------
    create_table :users do |t|
      t.string :name
      t.string :locale, limit: 10
      #t.boolean :trusted, default: false
      #t.boolean :group, default: false

      t.string :authentication_token, index: true, unique: true, limit: 30

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end
    create_trigger(compatibility: 1).on(:users).before(:update) do
      'NEW.updated_at = NOW();'
    end
    # ----------
    create_table :endpoints do |t|
      t.string :name
      # TODO: Store PC parameters here
      t.text :data
      #t.string :key, index: true, null: false, default: -> { 'md5(random()::text || clock_timestamp()::text)::uuid' }
      t.string :eid, null: false, default: ""

      t.belongs_to :user, index: true, optional: true

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at, index: true
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
      t.string :text
      t.string :version
      t.string :key, index: true, null: false, default: -> { 'md5(random()::text || clock_timestamp()::text)::uuid' }

      t.string :tags, null: false, default: ''
      #t.boolean :unstable, null: false, default: false
      #t.boolean :deprecated, null: false, default: false

      t.belongs_to :user, index: true, optional: true
      # You can link packages one to another to chain updates
      t.belongs_to :package, index: true, optional: true
      # The package can be a part of product
      t.belongs_to :product, index: true, optional: true

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at, index: true
      # Packages will be unique for everyone or for selected user
      t.index [:user_id, :name], unique: true
    end
    create_trigger(compatibility: 1).on(:packages).before(:update) do
      'NEW.updated_at = NOW();'
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
    create_trigger(compatibility: 1).on(:dependencies).before(:update) do
      'NEW.updated_at = NOW();'
    end
    # ----------
    create_table :settings do |t|
      # Application related variables and settings
      t.text :data
      # Log tails etc.
      t.text :log
      # TODO: Purchase information

      t.belongs_to :endpoint
      t.belongs_to :package

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at, index: true
      t.index [:endpoint_id, :package_id], unique: true
    end
    create_trigger(compatibility: 1).on(:settings).before(:update) do
      'NEW.updated_at = NOW();'
    end
    # ----------
    create_table :parts do |t|
      t.string :name, null: false
      t.string :description
      t.string :destination
      t.text :script # TODO: Encode script with user's key

      # Parts will be copied into chained updates
      t.belongs_to :package, index: true

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at, index: true
      t.index [:package_id, :name]
    end
    create_trigger(compatibility: 1).on(:parts).before(:update) do
      'NEW.updated_at = NOW();'
    end
    # ----------
    create_table :products do |t|
      t.string :title, null: false
      # TODO: Search string?
      t.text :text
      t.string :key, index: true, null: false, default: -> { 'md5(random()::text || clock_timestamp()::text)::uuid' }
      t.boolean :approved, null: false, default: false
      t.boolean :published, null: false, default: false

      t.belongs_to :user, index: true, optional: true

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :discarded_at, index: true
    end
    create_trigger(compatibility: 1).on(:products).before(:update) do
      'NEW.updated_at = NOW();'
    end
  end
end
