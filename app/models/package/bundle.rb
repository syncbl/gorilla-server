class Package::Bundle < Package::Default
  before_validation :set_type, on: :create

  validates :external_url,
            inclusion: [nil]

  # TODO: Bundle is a package without files, only dependent packages

  private

  def set_type
    self.package_type = :bundle
  end
end
