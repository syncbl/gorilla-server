# TODO: Scrapper for package monitoring

class Package::Monitor < Package::External
  jsonb_accessor :params,
                 external_url: [:string]

  validates :external_url,
            format: {
              with: URI::DEFAULT_PARSER.make_regexp(%w[https http]),
              message: I18n.t("errors.messages.url_is_not_allowed"),
            },
            length: { maximum: 2048 },
            presence: true
  validates :params, external_params: true

  before_validation :auto_publish, on: :create

  private

  def auto_publish
    self.published_at = Time.current
  end
end
