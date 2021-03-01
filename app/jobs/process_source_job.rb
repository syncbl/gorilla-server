class ProcessSourceJob < ApplicationJob
  require "timeout"

  queue_as :default

  def perform(source, **args)
    file = args[:file]

    if file = ActiveStorage::Blob.find_by(checksum: args[:checksum])
      # TODO: Warn about existing file if it's own or public
    end

    Timeout::timeout(JOB_TIMEOUT) do
      # TODO: unless Clamby.safe?(file)
      #  source.block! I18n.t("jobs.block_reasons.suspicious_attachment")
      #  return false
      #end
      source.attach(file)
      File.delete(file)

      # Merge while file is not attached and deleted
      #MergeSources.perform(source.package)

      # TODO: Inform user
    end

    # TODO: Flatten before delete to save some traffic

  rescue Timeout::Error
    source.block! "+++ TIMEOUT +++"
  end
end
