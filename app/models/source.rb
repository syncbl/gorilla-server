class Source < ApplicationRecord
  self.implicit_order_column = :created_at

  belongs_to :package

  has_one_attached :attachment

  validates :external_url, format: URI::regexp(%w[http https]), allow_blank: true

  # TODO: There is a potential to make this polymorphic for internal and external resources
end
