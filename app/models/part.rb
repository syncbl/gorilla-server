class Part < ApplicationRecord
  include Discard::Model

  belongs_to :package
end
