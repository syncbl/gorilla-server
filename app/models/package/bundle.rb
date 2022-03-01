class Package::Bundle < Package::Internal
  jsonb_accessor :params,
                 uninstall: [:string],
                 root: [:string], # TODO: Default value?
                 path: [:string],
                 path_persistent: [:boolean],
                 # TODO: Main applications dictionary?
                 main_application_reg_key: [:string],
                 require_administrator: [:boolean],
                 require_restart: [:boolean]

  enumerize :root, in: ROOT_ENUMERATOR

  def self.model_name
    Package.model_name
  end
end
