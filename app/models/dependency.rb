class Dependency < ApplicationRecord
  extend Enumerize

  belongs_to :package
  belongs_to :dependent_package,
             class_name: "Package"

  # Types of dependency:
  # - dependent (install after main package as part)
  # - required (must be installed before main package)
  # - optional (user can install or not)
  enumerize :dependency_type,
            in: [:dependent, :required, :optional],
            scope: true

end
