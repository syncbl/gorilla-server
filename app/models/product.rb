class Product < ApplicationRecord
  include Discard::Model
  has_many_attached :images
  has_many :packages, dependent: :nullify
end
