class Group < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :users,
                          class_name: "User",
                          join_table: :group_members
end
