class Package::Component < Package::InternalBase
  has_many :packages, through: :dependencies

  before_destroy :check_dependency, prepend: true

  # def orphaned?
  #   Dependency.where(dependent_package: self).empty?
  # end

  # private

  # def check_dependency
  #   return if orphaned?

  #   errors.add :dependent_package, :used
  #   throw :abort
  # end
end
