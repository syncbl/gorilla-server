class Group < ApplicationRecord
  belongs_to :groupable, polymorphic: true
end
