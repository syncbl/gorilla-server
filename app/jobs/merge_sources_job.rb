class MergeSourcesJob < ApplicationJob
  queue_as :default

  def perform(package)
    return false unless package.internal? && (package.sources.size > 1)

    # TODO: Iterate through sources
    # From last to first -> delete existing old files

    # TODO: Don't show merged sources and don't allow to delete them
    # ! Purge file from source before processing to make it unavailable

    # Set merged: true for processed packages
  end
end
