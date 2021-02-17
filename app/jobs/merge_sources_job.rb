class MergeSourcesJob < ApplicationJob
  queue_as :default

  def perform(package)
    return false unless package.sources.size > 1

    source = package.sources.last

    package.sources.each_with_index.reverse_each.map do |s, i|
      break if i == 0

      # From i - 1 downto 0 compare filelists

      destination = package.sources[i - 1]

      source.flatfilelist

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
