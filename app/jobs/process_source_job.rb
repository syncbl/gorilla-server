class ProcessSourceJob < ApplicationJob
  require "timeout"

  queue_as :default

  def perform(source, **args)
    filename = args[:filename]

    if file = ActiveStorage::Blob.find_by(checksum: args[:checksum])
      # TODO: Warn about existing file if it's own or public
    end

    Timeout::timeout(5.minutes) do
      source.update_state I18n.t("jobs.process_source.scanning")

      # TODO: clamscan
      #if Clamby.virus?(filename)
      #  source.block! "+++ VIRUS +++"
      #  return false
      #end

      source.update_state I18n.t("jobs.process_source.building")
      if source.build(filename)
        source.update_state I18n.t("jobs.process_source.attaching")
        source.attach(io: File.open(filename),
                      filename: "#{source.package.name}-#{source.created_at.strftime("%y%m%d%H%M%S%2L")}.zip")
      end
      File.delete(filename)
      # TODO: Inform user

      source.update_state
    end

    # TODO: Flatten before delete to save some traffic

  rescue Timeout::Error
    source.block! "+++ TIMEOUT +++"
  end
end
