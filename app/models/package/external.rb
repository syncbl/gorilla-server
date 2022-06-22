class Package::External < Package::ExternalBase
  jsonb_accessor :params,
                 checksum: [:string],
                 switches: [:string],
                 uninstall: [:string],
                 version: [:string]

  # TODO: validates :params, external_params: true

  before_validation :auto_publish, on: :create

  private

  def auto_publish
    self.published_at = Time.current
  end
end
