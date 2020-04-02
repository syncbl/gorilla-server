class GenerateManifestJob < ApplicationJob
  queue_as :default

  def perform(package)
    package.files.each do |f|
      

    end
  end
end
