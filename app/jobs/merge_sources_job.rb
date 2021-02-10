class MergeSourcesJob < ApplicationJob
  queue_as :default

  def perform(package)
    return false unless package.internal? && (package.sources.size > 1)

    package.sources.each_with_index.reverse_each.map do |source, i|
      break if i == 0
      source.update_state I18n.t("jobs.process_source.merging")

      # From i - 1 downto 0 compare filelists

      destination = package.sources[i - 1]
      destination.update_state I18n.t("jobs.process_source.merging")

      source.flatten_filelist

    end

    # TODO: Iterate through sources
    # From last to first -> if file exists in filelist
    # then delete existing old files, then rebuild filelist in every source,
    # then MAY BE create complete filelist for package

    # TODO: Don't show merged sources and don't allow to delete them
    # ! Purge file from source before processing to make it unavailable

    # Set 'merged: true' for processed packages
    # Package.size = Sum(source.unpacked_size)
  end
end
