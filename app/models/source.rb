class Source < ApplicationRecord
  self.implicit_order_column = :created_at

  belongs_to :package

  has_one_attached :attachment

  # TODO: There is a potential to make this polymorphic for internal and external resources
  validates :external_url, format: URI::regexp(%w[http https]), allow_blank: true

  def internal_url?
    type == :internal_url
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
    if attachment.attached?
      :internal_url
    elsif external_url.present?
      :external_url
    end
  end
end
