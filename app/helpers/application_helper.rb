module ApplicationHelper
  include Pagy::Frontend
  include Api::Cache

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
      if current_user&.owner?(object)
        object.name
      else
        "#{object.user.name}/#{object.name}"
      end
    when Endpoint
      object.name
    when User
      object.fullname
    end
  end

  def log_json(json)
    if Rails.env.development?
      Logger.new(Rails.root.join("log/json.log"))
            .debug "#{caller[0].split(%r{[/:]})[-4..-3].join("/")}:\n#{JSON.pretty_generate(json)}"
    end
    json
  end

  def render_403(reason = nil)
    reason ||= I18n.t("errors.messages.forbidden")
    respond_to do |format|
      format.html do
        if user_signed_in?
          render "errors/403", layout: "errors", status: :forbidden
        else
          redirect_to new_user_session_path, status: :forbidden
        end
      end
      format.json { render_json_error reason, status: :forbidden }
    end
  end

  def render_404
    respond_to do |format|
      format.html do
        if user_signed_in?
          render "errors/404", layout: "errors", status: :not_found
        else
          redirect_to new_user_session_path, status: :forbidden
        end
      end
      format.json { render_json_error I18n.t("errors.messages.not_found"), status: :not_found }
    end
  end

  def render_json_error(messages, status:)
    if messages.is_a? Array
      render json: { errors: messages }, status: status
    else
      render json: { error: messages }, status:
    end
  end

  def current_anyone
    current_endpoint || current_user
  end

  def someone_signed_in?
    current_endpoint.present? || current_user.present?
  end
end
