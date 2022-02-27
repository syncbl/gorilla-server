class Package::External < Package
  jsonb_accessor :params,
                 external_url: [:string],
                 checksum: [:string],
                 switches: [:string],
                 uninstall: [:string],
                 version: [:string],
                 searcheable: [:boolean]

  # TODO: More validation messages
  validates :name,
            name_restrict: true,
            presence: true,
            length: {
              minimum: MIN_NAME_LENGTH,
              maximum: MAX_NAME_LENGTH,
            },
            uniqueness: {
              case_sensitive: false,
            },
            format: {
              with: NAME_FORMAT,
            }
  validates :external_url,
            format: {
              with: URI::DEFAULT_PARSER.make_regexp(%w[https http]),
              message: I18n.t("errors.messages.url_is_not_allowed"),
            },
            length: { maximum: 2048 },
            presence: true

  before_validation :auto_publish, on: :create

  scope :searcheable, -> {
    not_blocked.published.params_where(searcheable: true)
  }

  def self.model_name
    Package.model_name
  end

  def publishable?
    external_url.present?
  end

  private

  def auto_publish
    self.published_at = Time.current
  end
end
