class Company < ApplicationRecord

  has_many :users
  has_many :endpoints, through: :users

  validates :name, uniqueness: { case_sensitive: false }
end
