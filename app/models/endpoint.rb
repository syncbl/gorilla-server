class Endpoint < ApplicationRecord
  include Discard::Model
  #acts_as_taggable

  belongs_to :user
  has_and_belongs_to_many :packages
end
