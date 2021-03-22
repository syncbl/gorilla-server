class CreateFriendships < ActiveRecord::Migration[6.0]
  def self.up
    create_table :friendships do |t|
      t.references :friendable, polymorphic: true
      t.integer  :friend_id
      t.integer  :blocker_id
      t.integer  :status

      t.datetime :created_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :updated_at, index: true, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index [:friendable_id, :friend_id], unique: true
    end
  end

  def self.down
    drop_table :friendships
  end
end
