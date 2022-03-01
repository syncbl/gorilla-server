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
end
