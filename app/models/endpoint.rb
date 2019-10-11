class Endpoint < ApplicationRecord
  include Discard::Model
  acts_as_taggable

  belongs_to :user
  has_many :settings, dependent: :destroy
  has_many :packages, through: :settings

  default_scope -> {
    kept.
    order(user_id: :asc)
  }
end
