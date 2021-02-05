class ProcessSourceJob < ApplicationJob
  require "timeout"

  queue_as :default

  def perform(source, **args)
    filename = args[:filename]

    if file = ActiveStorage::Blob.find_by(checksum: args[:checksum])
      # TODO: Warn about existing file if it's own or public
    end

    Timeout::timeout(JOB_TIMEOUT) do
      source.update_state I18n.t("jobs.process_source.scanning")

      unless Clamby.safe?(filename)
        source.block! I18n.t("jobs.block_reasons.suspicious_attachment")
        return false
      end

      source.update_state I18n.t("jobs.process_source.attaching")
      source.attach(filename)
      File.delete(filename)
      # TODO: Inform user
      source.update_state
    end

    # TODO: Flatten before delete to save some traffic

  rescue Timeout::Error
    source.block! "+++ TIMEOUT +++"
  end
end
