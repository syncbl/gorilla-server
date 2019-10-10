class Endpoint < ApplicationRecord
  include Discard::Model
  #acts_as_taggable

  default_scope -> {
    order(user_id: :asc)
  }

  scope installed, -> {
    kept
  }

  belongs_to :user
  has_many :settings, dependent: :destroy
  has_many :packages, through: :settings
end
