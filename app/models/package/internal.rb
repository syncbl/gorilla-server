class Package::Internal < Package
  include ParamAwareable

  before_validation :set_type, on: :create
  validates_with InternalPackageValidator

  def publishable?
    true
  end

  def available_files
    available_files = Set[]
    sources.map do |s|
      available_files += s.files.keys
      available_files -= s.delete_files
    end
    available_files
  end

  private

  def set_type
    raise Exception::NotImplementedError
  end
end