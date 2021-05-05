module ApplicationHelper
  include Pagy::Frontend
  include ErrorHelper

  def alert_for(flash_type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info",
    }[
      flash_type.to_sym
    ] || flash_type.to_s
  end

  def title(object)
    case object
    when Package
      (object.user == current_user) ? object.name :
        "#{object.user.name}/#{object.name}"
    when User
      "#{object.user.fullname}"
    end
  end

  def cache_fetch(model, id, token)
    Rails.cache.fetch(
      "#{model.name}_#{id}",
      expires_in: MODEL_CACHE_TIMEOUT,
    ) do
      model.active.find_by(
        id: id,
        authentication_token: token,
      )
    end
  end

  def cached_endpoint(id, token)
    @_cached_endpoint ||= cache_fetch(Endpoint, id, token)
  end

  def cached_user(id, token)
    @_cached_user ||= cache_fetch(User, id, token)
  end

  def current_endpoint
    @_cached_endpoint
  end

  def sign_in_endpoint(endpoint)
    endpoint.reset_token
    @_cached_endpoint ||= endpoint
  end

  def log_json(json, file)
    Rails.logger.debug "+++ #{file}:\n#{JSON.pretty_generate(json)}"
  end

  def json_time(time)
    time.nil? ? nil : time.to_i
  end

  # TODO: Render 403
  def check_view!(object)
    head :forbidden unless current_user&.can_view? object
  end

  def check_edit!(object)
    head :forbidden unless current_user&.can_edit? object
  end
end
