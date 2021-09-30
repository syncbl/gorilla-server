class Dependency < ApplicationRecord
  belongs_to :package
  belongs_to :dependent_package, class_name: "Package"

  delegate :package_type, to: :dependent_package

  validates :dependent_package, package_dependency: true

  def required_component?
    package_type.component? && !is_optional
  end

  def optional_component?
    package_type.component? && is_optional
  end

  def required_package?
    !package_type.component? && !is_optional
  end

  def optional_package?
    !package_type.component? && is_optional
  end

  def self.extract(package)
    columns = Dependency.column_names
    sql =
      <<-SQL
        WITH RECURSIVE dependency_tree (#{columns.join(",")}, level)
        AS (
          SELECT
            #{columns.join(", ")}, 0
          FROM dependencies
          WHERE id IN (
            SELECT
              dependencies.id
            FROM dependencies, packages
            WHERE package_id = '#{package.id}'
            AND packages.id = dependencies.package_id
            AND packages.blocked_at IS NULL
          )

          UNION ALL

          SELECT
            #{columns.map { |col| "dependencies." + col }.join(", ")}, level + 1
          FROM dependencies, dependency_tree, packages
          WHERE dependencies.package_id = dependency_tree.dependent_package_id
          AND packages.id = dependencies.dependent_package_id
          AND dependencies.is_optional = FALSE
          AND packages.blocked_at IS NULL
        )
        SELECT * FROM dependency_tree
      SQL

    if dependencies = Dependency.find_by_sql(sql.chomp)
      ActiveRecord::Associations::Preloader.new.preload dependencies, [:package, :dependent_package]
      dependencies
    else
      []
    end
  end
end
