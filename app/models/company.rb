class Company < ApplicationRecord
  include Discard::Model

  has_many :users

end
