class Part < ApplicationRecord
  include Discard::Model
  acts_as_taggable

  belongs_to :package

  default_scope -> {
    kept
  }
end
