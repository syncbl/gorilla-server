class Category < ApplicationRecord
  translates :caption

  has_many :packages

  validates :caption,
            length: {
              maximum: MAX_NAME_LENGTH,
            },
            format: {
              with: NAME_FORMAT,
            }
end
