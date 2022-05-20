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
              message: I18n.t("errors.messages.url_is_not_allowed"),
            },
            length: { maximum: 2048 },
            presence: true
  validates :params, external_params: true

  before_validation :auto_publish, on: :create

  def self.model_name
    Package.model_name
  end

  def publishable?
    super && external_url.present?
  end

  private

  def auto_publish
    self.published_at = Time.current
  end
end
