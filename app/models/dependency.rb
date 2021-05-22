class Dependency < ApplicationRecord
  extend Enumerize

  belongs_to :package
  belongs_to :dependent_package,
             class_name: "Package"

  # Types of dependency:
  # - component (install after main package as part)
  # - required (must be installed before main package)
  # - optional (user can install or not)
  enumerize :dependency_type,
            in: [:component, :required, :optional],
            default: :component,
            scope: true

  validates :dependent_package,
            dependency_published: true

  # TODO: Check dependency:
  # - not same id
  # - no crossreference
end
