class Source < ApplicationRecord
  include Discard::Model
  include Blockable

  belongs_to :package

  has_one_attached :file,
                   service: :remote,
                   dependent: :purge_later

  validates :file,
            size: { less_than: MAX_FILE_SIZE }
  validates :description,
            length: { maximum: MAX_DESCRIPTION_LENGTH }
  validates :version,
            length: { maximum: MAX_VERSION_LENGTH }

  # TODO: pluck

  default_scope { joins(:file_attachment) }

  scope :published, -> {
    where(Source.arel_table[:published_at].lt(Time.current))
  }

  def self.merged?
    last&.is_merged == true
  end

  def ready?
    file&.attached?
  end
end
