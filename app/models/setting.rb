class Setting < ApplicationRecord
  include Discard::Model
  acts_as_taggable

  belongs_to :package
  belongs_to :endpoint

  default_scope -> {
    kept
  }
end
