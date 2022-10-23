class Package::ExternalBase < Package
  jsonb_accessor :params,
                 external_url: [:string]

  validates :external_url,
            format: {
              with: URI::DEFAULT_PARSER.make_regexp(%w[https http]),
              message: :not_allowed
            },
            length: { maximum: 2048 },
            presence: true
  # TODO: validates :params, external_params: true
end
