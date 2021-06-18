class ProcessSourceJob < ApplicationJob
  def safe_perform(source, file)
    AttachmentService.call source, file
  end
end
