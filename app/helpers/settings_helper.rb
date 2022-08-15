module SettingsHelper
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
      unless package.match? UUID_FORMAT
        # TODO: Standardize error response
        raise ActiveRecord::RecordNotFound, "Couldn't find Package with 'id'=#{package}"
      end

      packages << authorize!(:show, Package.includes(:user).find(package))
    end

    packages
  end
end
