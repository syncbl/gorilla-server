module ErrorHelper
  def render_error(error, status:)
    if errors.is_a? Array
      render json: { errors: error }, status: status
    else
      render json: { error: error }, status: status
    end
  end

  def respond_error(message, status)
    respond_to do |format|
      format.html { flash.now :error, message }
      format.json { render_error message, status }
    end
  end
end
