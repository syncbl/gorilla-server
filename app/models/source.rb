class Source < ApplicationRecord
  include Discard::Model
  include Blockable
  include Publishable

  attribute :size

  belongs_to :package
  has_one_attached :file,
                   service: :external,
                   dependent: :purge_later
  encrypts_attached :file

  validates :file,
            size: { less_than: MAX_FILE_SIZE }
  validates :description,
            length: { maximum: MAX_DESCRIPTION_LENGTH }
  validates :version,
            length: { maximum: MAX_VERSION_LENGTH }
  validates_with SourceValidator

  default_scope { joins(:file_attachment) }

  def self.merged?
    last&.is_merged == true
  end

  def validated?
    validated_at.present?
  end

  def published?
    published_at.present?
  end

  private

  def check_publishable
    if published_at.present? && !validated?
      errors.add(:published_at, I18n.("errors.messages.cannot_publish"))
    end
  end
end
