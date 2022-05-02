class Package::Internal < Package
  include ParamAwareable

  jsonb_accessor :params,
                 path: [:string]

  validates :params, internal_params: true

  def self.model_name
    Package.model_name
  end

  def publishable?
    # TODO: Check files or at least params
    true
  end

  # TODO: Mark orphaned
  def orphaned?
    packages.size.zero?
  end

  def available_files
    available_files = Set[]
    sources.map do |s|
      available_files += s.files.keys
      available_files -= s.delete_files
    end
    available_files
  end
end