class Product < ApplicationRecord
  include Discard::Model

  # TODO: has_one_attached different sizes
  has_one_attached :icon
  has_many_attached :images
  has_one :package, dependent: :nullify
  belongs_to :user, optional: true

  scope :available_for, -> (user = nil) {
    #where(user: user, published: true).or(where(user: nil, approved: true))
  }

  default_scope -> {
    kept
    .joins(:package)
    .with_attached_icon
  }

end
