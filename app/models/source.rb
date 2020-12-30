class Source < ApplicationRecord
  self.implicit_order_column = :created_at

  belongs_to :package, polymorphic: true

  has_one_attached :file

  # TODO: Check link for content disposition
  validates :external_url, format: URI.regexp(%w[http https]), allow_nil: true
  validates :file,
            content_type: 'application/zip',
            size: { less_than: 1.gigabyte }

  def internal_file?
    type == :internal_file
  end

  def external_url?
    type == :external_url
  end

  def undefined?
    type.nil?
  end

  private

  # TODO: Add task to delete all sources where no content
  def type
    return :internal_file if file.attached?
    return :external_url if external_url.present?
  end
end
