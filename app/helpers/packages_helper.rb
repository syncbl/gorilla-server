module PackagesHelper
  def find_package_by_params
    if params[:user_id].present? && params[:package_id].present?
      Package
        .where(user: { name: params[:user_id] })
        .find_by!(name: params[:package_id])
    else
      Package.find(params[:id])
    end
  end

  def get_package_class
    case params[:package][:type]
    when "Package::Bundle"
      Package::Bundle
    when "Package::Component"
      Package::Component
    when "Package::External"
      Package::External
    #else
    #  Package
    end
  end
end
