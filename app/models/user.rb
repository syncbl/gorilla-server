class User < ApplicationRecord
  include Discard::Model

  has_many :packages
end
