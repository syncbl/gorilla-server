class MergeSourcesJob < ApplicationJob
  queue_as :disk

  def safe_perform(package)
    MergeSourcesService.call package
  end
end
