class Source < ApplicationRecord
  self.implicit_order_column = :created_at

  belongs_to :package

  has_one_attached :attachment

  # TODO: There is a potential to make this polymorphic for internal and external resources
  validates :external_url, format: URI::regexp(%w[http https]), allow_nil: true

  after_destroy do
    attachment.purge_later
  end

  def internal_file?
    type == :internal_file
  end

  def external_url?
    type == :external_url
  end

  def undefined?
    type.nil?
  end

  def self.empty
    Source.where(Source.arel_table[:created_at].lt(Time.current - Rails.application.config.syncbl.empty_source_erase_after))
      .select { |source| source.undefined? }
  end

  private

  # TODO: Add task to delete all sources where no content
  def type
    return :internal_file if attachment.attached?
    return :external_url if external_url.present?
  end

end
