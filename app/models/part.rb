class Part < ApplicationRecord
  has_many_attached :files
  # TODO: Pack parts into archive?
  has_one_attached :archive
  belongs_to :package

  default_scope -> {
    with_attached_archive
  }
end
