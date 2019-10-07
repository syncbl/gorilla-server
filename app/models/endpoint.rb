class Endpoint < ApplicationRecord
  include Discard::Model

  belongs_to :user
  has_and_belongs_to_many :packages
end
