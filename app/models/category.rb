class Category < ApplicationRecord
  translates :caption

  has_many :packages, dependent: :nullify

  validates :caption,
            presence: true,
            length: {
              maximum: MAX_NAME_LENGTH
            },
            format: {
              with: NAME_FORMAT
            }
end
