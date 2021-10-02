class Dependency < ApplicationRecord
  translates :category

  belongs_to :package
  belongs_to :dependent_package, class_name: "Package"

  delegate :package_type, to: :dependent_package

  validates :dependent_package, package_dependency: true
  validates :category,
            length: {
              maximum: MAX_NAME_LENGTH,
            },
            format: {
              with: NAME_FORMAT,
            }

  scope :categorized, -> {
          order(Arel.sql("category_translations ->>'#{I18n.locale}', category_translations ->>'en'"))
        }

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

  def self.extract_from(endpoint)
    columns = Dependency.column_names
    sql =
      <<-SQL
        WITH RECURSIVE dependency_tree (#{columns.join(", ")}, level)
        AS (
          SELECT
            #{columns.join(", ")}, 0
          FROM dependencies
          WHERE id IN (
            SELECT
              dependencies.id
            FROM dependencies, packages, settings
            WHERE settings.endpoint_id = '#{endpoint.id}'
            AND settings.package_id = dependencies.package_id
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

    dependencies = Dependency.find_by_sql(sql.chomp)
    ActiveRecord::Associations::Preloader.new.preload dependencies, [
                                                        { package: :user },
                                                        { dependent_package: :user },
                                                        { package: :sources },
                                                        { dependent_package: :sources },
                                                      ]
    dependencies || []
  end
end
