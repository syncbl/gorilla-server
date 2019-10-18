class User < ApplicationRecord
  include Discard::Model

  has_many :packages, dependent: :destroy
  has_many :endpoints
  belongs_to :user, optional: true

  default_scope -> {
    kept
  }
end
