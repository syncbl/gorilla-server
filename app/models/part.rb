class Part < ApplicationRecord
  include Discard::Model

  belongs_to :package

  default_scope -> {
    kept
  }
end
