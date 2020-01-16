module ApplicationHelper

  def service_key(path)
    "#{File.basename(path)}:#{Digest::MD5.file(path).base64digest}"
  end

  def service_keys
    # TODO: Cache results!
    [
      "###DEV###",
      service_key(Rails.application.config.service_path)
    ]
  end
end
