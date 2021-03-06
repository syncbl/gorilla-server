class ProcessSourceJob < ApplicationJob
  require "timeout"

  queue_as :default

  def perform(source, **args)
    Timeout::timeout(JOB_TIMEOUT) do
      # TODO: unless Clamby.safe?(file)
      #  source.block! I18n.t("jobs.block_reasons.suspicious_attachment")
      #  return false
      #end
      source.attach(args[:file])
      File.delete(args[:file])

      # Merge while file is not attached and deleted
      #MergeSources.perform(source.package)

      # TODO: Inform user
    end

    # TODO: Flatten before delete to save some traffic

  rescue Timeout::Error
    source.block! "+++ TIMEOUT +++"
  end
end
