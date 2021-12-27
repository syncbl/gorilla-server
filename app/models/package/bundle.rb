class Package::Bundle < Package::Internal
  jsonb_accessor :params,
                 uninstall: [:string],
                 root: [:string], # TODO: Default value?
                 path: [:string],
                 path_persistent: [:boolean, default: false],
                 # TODO: Main applications dictionary?
                 main_application_reg_key: [:string],
                 require_administrator: [:boolean, default: false],
                 require_restart: [:boolean, default: false]

  enumerize :root, in: ROOT_ENUMERATOR

  default_scope { with_package_type(:bundle) }

  private

  def set_type
    self.package_type = :bundle
  end
end
