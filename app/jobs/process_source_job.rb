class ProcessSourceJob < ApplicationJob
  def safe_perform(source, file)
    # TODO: Check tmp for free space left
    AttachmentService.call source, file
  end
end
