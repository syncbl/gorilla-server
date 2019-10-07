module Settings
  extend self

  def storage_packages
    get_setting(['smtp', 'domain'])
  end

  private

  SETTINGS_FILE = 'config/settings.yml'

  def get_setting(path)
    YAML.load_file(SETTINGS_FILE).dig(*path)
  end

  def get_setting_eval(path)
    YAML.load_file(SETTINGS_FILE).dig(*path)
  end
end