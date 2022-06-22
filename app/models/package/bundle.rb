class Package::Bundle < Package::InternalBase
  jsonb_accessor :params,
                 uninstall: [:string],
                 root: [:string, default: "default_storage"],
                 main_application_reg_key: [:string],
                 require_administrator: [:boolean],
                 require_restart: [:boolean]

  enumerize :root, in: ROOT_ENUMERATOR
end
