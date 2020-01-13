class Part < ApplicationRecord
  has_many_attached :files
  # TODO: Worker will pack all the attached files to archive. We need to set a flag for package.
  has_one_attached :archive
  belongs_to :package, touch: true

  default_scope -> {
    with_attached_archive
    .with_attached_files
  }
end
