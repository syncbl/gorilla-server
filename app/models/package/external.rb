class Package::External < Package
  jsonb_accessor :params,
                 external_url: [:string],
                 checksum: [:string],
                 switches: [:string],
                 uninstall: [:string]

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
              with: URI.regexp(%w[https http]),
              message: I18n.t("errors.messages.url_is_not_allowed"),
            },
            length: { maximum: 2048 },
            presence: true

  before_validation :set_type, on: :create

  default_scope { with_package_type(:external) }

  def publishable?
    external_url.present?
  end

  private

  def set_type
    self.package_type = :external
    # TODO: ?
    self.published_at = Time.current
  end
end
