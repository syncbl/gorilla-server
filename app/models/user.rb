class User < ApplicationRecord
  include Discard::Model

  has_many :packages, dependent: :destroy
  has_many :endpoints, dependent: :destroy
  belongs_to :user, optional: true
end
