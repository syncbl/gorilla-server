class Product < ApplicationRecord
  include Discard::Model

  has_many_attached :images
  has_one :package, dependent: :nullify
  belongs_to :user, optional: true

  scope :available_for, -> (user = nil) {
    #where(user: user, published: true).or(where(user: nil, approved: true))
  }

  default_scope -> {
    kept
    .joins(:package)
  }

end
