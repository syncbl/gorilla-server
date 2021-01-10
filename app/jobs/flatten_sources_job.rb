class FlattenSourcesJob < ApplicationJob
  queue_as :default

  def perform(package, source)
    return false unless package.internal? && source.present?

    # TODO: Iterate through sources
    # 1. Concatenate with 0
    # 2. Delete existing files from last to second: 3 into 2, 2 into 1 etc.
    # If settings.updated_at < source.updated_at then install.
    # TODO: Allow to delete after flatten, but warn user that then only full package update will be available
    # ! Purge file from source before processing to make it unavailable
  end
end
