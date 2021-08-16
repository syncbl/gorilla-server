class Package::External < Package
  jsonb_accessor :params,
                 external_url: [:string],
                 checksum: [:string],
                 hash_type: [:string],
                 switches: [:string],
                 uninstall: [:string]
  enumerize :hash_type,
            in: %i[md5 sha256]

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
            format: { with: NAME_FORMAT }
  validates :external_url,
            format: { with: URI.regexp(%w[https http]), message: I18n.t('errors.messages.url_is_not_allowed') },
            length: { maximum: 2048 },
            presence: true,
            package_external_url: true
  validates :is_external, inclusion: [true]

  default_scope -> {
                  where(is_component: false, is_external: true)
                }
  validates :is_component, inclusion: [false]

  before_validation :set_type, on: :create

  private

  def set_type
    self.package_type = :external
    self.is_component = false
    self.is_external = true
    self.validated_at = Time.current
    # TODO: ?
    self.published_at = Time.current
  end
end
