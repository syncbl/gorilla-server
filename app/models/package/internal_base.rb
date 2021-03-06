class Package::InternalBase < Package
  include ParamAwareable

  jsonb_accessor :params,
                 path: [:string]

  validates :params, internal_params: true

  def publishable?
    super && sources.where.not(published_at: nil).any?
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
