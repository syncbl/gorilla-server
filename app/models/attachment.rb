class Attachment < ApplicationRecord
  self.implicit_order_column = :created_at

  belongs_to :package

  has_one_attached :archive

  validates :external_url, format: URI::regexp(%w[http https]), allow_blank: true

end
