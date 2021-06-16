class Package::Bundle < Package::Default
  validates :external_url,
            inclusion: [nil]

  # TODO: Bundle is a package without files, only dependent packages
end
