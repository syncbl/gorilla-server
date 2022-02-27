class Package::Component < Package::Internal
  has_many :packages, through: :dependencies

  jsonb_accessor :params,
                 path: [:string, default: ""]

  before_destroy :check_dependency, prepend: true

  def self.model_name
    Package.model_name
  end

  private

  def check_dependency
    unless orphaned?
      # TODO: Relative path to error
      errors.add :size, I18n.t("errors.attributes.dependency.used")
      throw :abort
    end
  end
end
