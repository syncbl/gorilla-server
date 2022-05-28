class Package::ExternalBase < Package
  jsonb_accessor :params,
                 external_url: [:string]

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
end
