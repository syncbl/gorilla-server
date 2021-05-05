class MergeSourcesJob < ApplicationJob
  def safe_perform(package)
    MergeSourcesService.call package
  end
end
