class Endpoint < ApplicationRecord
  belongs_to :user
  has_many :settings, dependent: :destroy
  has_many :packages, through: :settings

  default_scope -> {
    order(user_id: :asc)
  }

  def to_param
    key
  end
end
