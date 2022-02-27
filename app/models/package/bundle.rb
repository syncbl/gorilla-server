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

  def self.model_name
    Package.model_name
  end
end
