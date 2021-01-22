class ProcessSourceJob < ApplicationJob
  require "timeout"
  # TODO: Add Timeout stuff

  queue_as :default

  def perform(source, **args)
    filename = args[:filename]

    if file = ActiveStorage::Blob.find_by(checksum: args[:checksum])
      # TODO: Warn about existing file if it's own or public
    end

    source.update_state I18n.t("jobs.process_source.scanning")

    # TODO: clamscan
    #if Clamby.virus?(filename)
    #  source.block! "+++ VIRUS +++"
    #  return false
    #end

    source.update_state I18n.t("jobs.process_source.building")
    if source.build(filename)
      source.update_state I18n.t("jobs.process_source.attaching")
      source.attach(io: File.open(filename), filename: "#{Time.now.strftime("%Y%m%d%H%M%S")}.zip")
    end
    File.delete(filename)
    # TODO: Inform user
    source.update_state

    # TODO: Flatten before delete to save some traffic
  end
end
