class ExternalPackage < Package
  validates :external_url,
            format: URI.regexp(%w[https]),
            length: { maximum: 2048 },
            presence: true,
            package_external_url: true

  after_save :check_external_url

  private

  def check_external_url
    if saved_change_to_external_url?
      invalidate!
      CheckExternalUrlJob.perform_later self
    end
  end
end
