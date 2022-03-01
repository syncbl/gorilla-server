class Package::Bundle < Package::Internal
  jsonb_accessor :params,
                 uninstall: [:string],
                 root: [:string], # TODO: Default value?
                 path: [:string],
                 path_persistent: [:boolean],
                 # TODO: Main applications dictionary?
                 main_application_reg_key: [:string],
                 require_administrator: [:boolean],
                 require_restart: [:boolean],
                 # path:filepath
                 links_desktop: [:string, array: true],
                 links_startmenu: [:string, array: true]

  enumerize :root, in: ROOT_ENUMERATOR

  validates :links_desktop,
            package_link: true
  validates :links_startmenu,
            package_link: true

  def self.model_name
    Package.model_name
  end
end
