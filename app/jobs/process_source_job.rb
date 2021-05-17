class ProcessSourceJob < ApplicationJob
  def safe_perform(source, file)
    # TODO: unless Clamby.safe?(file)
    #  source.block! I18n.t("block_reasons.suspicious_attachment")
    #  return false
    #end
    AttachmentService.call source, file
  end
end
