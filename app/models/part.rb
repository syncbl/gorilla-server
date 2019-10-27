class Part < ApplicationRecord
  include Discard::Model

  has_many_attached :files
  belongs_to :package

  default_scope -> {
    kept
  }
end
