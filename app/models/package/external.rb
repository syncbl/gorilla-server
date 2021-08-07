class Package::External < Package::Bundle
  enumerize :hash_type,
            in: %i[md5 sha256]

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
            format: URI.regexp(%w[http https]),
            length: { maximum: 2048 },
            presence: true,
            package_external_url: true

  after_save :check_external_url
  before_validation :set_type, on: :create

  private

  def set_type
    self.package_type = :external
    self.validated?
  end

  def check_external_url
    if saved_change_to_external_url?
      invalidate!
      CheckExternalUrlJob.perform_later self
    end
  end
end
