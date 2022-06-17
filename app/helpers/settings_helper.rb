module SettingsHelper
  # TODO: Inderstand when 403 and when 404

  def packages_from_params
    ids = case package_params
      when Array
        package_params
      when String
        package_params.split(",")
      else
        []
      end

    packages = Set[]
    ids.each do |package|
      raise ActiveRecord::RecordNotFound unless package.match? UUID_FORMAT

      packages << authorize!(:show, Package.includes(:user).find(package))
    end

    packages
  end
end
