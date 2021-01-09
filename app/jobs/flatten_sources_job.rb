class FlattenSourcesJob < ApplicationJob
  queue_as :default

  def perform(package)
    return false unless package.internal?

    # TODO: Iterate through sources
    # 1. Add or replace files in [0]
    # 2. Delete existing files in [1..]
    # Warn user that after flatten there will be only full package update
  end
end
