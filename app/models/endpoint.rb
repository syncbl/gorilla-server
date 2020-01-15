class Endpoint < ApplicationRecord
  has_secure_token :authentication_token

  belongs_to :user
  has_many :settings, dependent: :destroy
  has_many :packages, through: :settings

  validates :key, length: {is: 36}, allow_blank: true

  def to_param
    key
  end
end
