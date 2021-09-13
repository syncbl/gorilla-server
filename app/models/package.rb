class Package < ApplicationRecord
  include PgSearch::Model
  include Blockable
  include Publishable
  include IdentityCache
  extend Enumerize

  # TODO: Markers to detect package is already installed:
  # - registry key
  # - file exists

  pg_search_scope :search_by_text,
                  against: %i[
                    name
                    caption_translations
                    description_translations
                  ]
  translates :caption, :description, :release_note
  enumerize :package_type, in: %i[bundle external component], scope: true
  strip_attributes

  belongs_to :user
  has_one :product
  has_many :settings, dependent: :nullify
  has_many :endpoints, through: :settings
  has_many :sources, dependent: :destroy
  has_many :dependencies
  has_many :dependent_packages, through: :dependencies
  belongs_to :replacement, class_name: "Package", optional: true
  has_one_attached :icon, service: :internal, dependent: :purge_later

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
  validates :package_type, presence: true
  validates :icon, size: { less_than: MAX_ICON_SIZE }
  validates :replacement, package_replacement: true
  validates :caption,
            presence: true,
            length: {
              minimum: MIN_NAME_LENGTH,
              maximum: MAX_NAME_LENGTH,
            }
  validates_with PackageSubscriptionValidator

  default_scope { joins(:user) }

  def replaced_by
    _replaced_by unless replacement_id.nil?
  end

  def generate_filelist!
    available_files = Set[]
    sources.map do |s|
      available_files += s.files.keys
      available_files -= s.delete_files
    end

    # TODO: Optimize
    update_column :files, available_files
  end

  def recalculate_size!
    old_size = size
    self.size = 0
    sources.each { |s| self.size += s.unpacked_size }
    user.notify(:flash_notice, self, I18n.t("notices.attributes.source.shrinked",
                                            size: old_size - self.size))
    save!
  end

  def filtered_params
    params.except(:allow_api_access)
  end

  def check_publishable
    raise Exception::NotImplementedError
  end

  private

  def _replaced_by
    # TODO: Check payment i.e.
    replacement_id.nil? ? self : replacement.replaced_by
  end
end
