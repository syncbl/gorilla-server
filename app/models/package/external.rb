class Package::External < Package::Bundle
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
