class Product < ApplicationRecord
  include Discard::Model

  has_many_attached :images
  has_one :package, dependent: :nullify

  default_scope -> {
    kept
  }
end
