class CheckExternalUrlJob < ApplicationJob
  require "timeout"

  queue_as :default

  def perform(package)
    Timeout::timeout(JOB_TIMEOUT) do
      if package.external_url.present?
        new_size = UrlRequest.get_attachment_size(package.external_url).to_i
        package.update(size: new_size)
      end
    rescue StandardError => e
      package.block! I18n.t("model.package.error.check_external_url")
      # TODO: Log e with url
    end
  rescue Timeout::Error
    source.block! "+++ TIMEOUT +++"
  end
end
