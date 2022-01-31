class Package < ApplicationRecord
  include PgSearch::Model
  include Blockable
  include Publishable
  include IdentityCache
  include SimpleTypeable
  extend Enumerize

  # TODO: Markers to detect package is already installed:
  # - registry key
  # - file exists

  pg_search_scope :search_by_text,
                  against: %i[
                    name
                    caption_translations
                    short_description_translations
                  ]
  translates :caption, :short_description, :description, :release_note
  attribute :category

  belongs_to :user
  has_one :product, dependent: :destroy
  has_many :settings, dependent: :nullify
  has_many :endpoints, through: :settings
  has_many :sources, dependent: :destroy
  has_many :dependencies, dependent: :destroy
  has_many :dependent_packages, through: :dependencies
  has_one_attached :icon, service: :local, dependent: :purge_later

  validates :name,
            name_restrict: true,
            presence: true,
            length: {
              minimum: MIN_NAME_LENGTH,
              maximum: MAX_NAME_LENGTH,
            },
            uniqueness: {
              scope: :user_id,
              case_sensitive: false,
            },
            format: {
              with: NAME_FORMAT,
            }
  validates :short_description,
            presence: true,
            length: {
              maximum: MAX_SHORT_DESCRIPTION_LENGTH,
            }
  validates :description,
            length: {
              maximum: MAX_DESCRIPTION_LENGTH,
            }
  validates :type, presence: true
  validates :icon, size: { less_than: MAX_ICON_SIZE }
  validates :caption,
            presence: true,
            length: {
              minimum: MIN_NAME_LENGTH,
              maximum: MAX_NAME_LENGTH,
            }
  validates_with PackageValidator

  before_validation :nullify_empty_params, on: :save

  default_scope do
    joins(:user) #.includes(:icon_attachment)
  end

  def recalculate_size!
    old_size = size
    self.size = 0
    sources.each { |s| self.size += s.unpacked_size }
    user.notify :flash_notice,
                self, I18n.t("notices.attributes.source.shrinked",
                             size: old_size - self.size)
    save!
  end

  def check_publishable
    raise NotImplementedError
  end

  def filtered_params
    params.except(:searcheable).compact
  end

  private

  def nullify_empty_params
    params.each { |k, v| params[k] = nil if v.empty? }
  end
end
