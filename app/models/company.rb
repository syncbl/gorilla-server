class Company < ApplicationRecord

  has_many :users
  has_many :endpoints, through: :users
end
