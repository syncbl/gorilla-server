class Product < ApplicationRecord
  include Discard::Model
  acts_as_taggable

  has_many_attached :images
  has_many :packages, dependent: :nullify

  default_scope -> {
    kept
  }
end
