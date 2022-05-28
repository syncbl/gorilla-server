class Package::External < Package
  jsonb_accessor :params,
                 external_url: [:string],
                 checksum: [:string],
                 switches: [:string],
                 uninstall: [:string],
                 version: [:string]

  validates :external_url,
            format: {
              with: URI::DEFAULT_PARSER.make_regexp(%w[https http]),
              message: I18n.t("errors.attributes.package.url_is_not_allowed"),
            },
            length: { maximum: 2048 },
            presence: {
              message: I18n.t("errors.attributes.package.external_url_is_empty")
            }
  # TODO: validates :params, external_params: true

  before_validation :auto_publish, on: :create

  private

  def auto_publish
    self.published_at = Time.current
  end
end
