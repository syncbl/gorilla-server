class Source < ApplicationRecord
  self.implicit_order_column = :created_at

  belongs_to :package

  has_one_attached :file

  validates :file,
            content_type: 'application/zip',
            size: { less_than: 1.gigabyte }

  def attach(**args)
    file.attach(args)
  end
end
