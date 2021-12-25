module ApplicationHelper
  include Pagy::Frontend

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
      if current_user.owner?(object)
        object.name
      else
        "#{object.user.name}/#{object.name}"
      end
    when User
      "#{object.user.fullname}"
    end
  end

  def current_endpoint
    @current_endpoint
  end

  def sign_in_endpoint(endpoint)
    @current_endpoint ||= endpoint
  end

  def log_json(json)
    if Rails.env.development?
      Logger.new(Rails.root.join("log/json.log"))
            .debug "#{caller[0].split(%r{[/:]})[-4..-3].join("/")}:\n#{JSON.pretty_generate(json)}"
    end
    json
  end

  def json_time(time)
    time.nil? ? nil : time.to_i
  end

  def current_anyone
    current_endpoint || current_user
  end
end
