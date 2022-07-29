class DependencyExtractService < ApplicationService
  def initialize(endpoint, package_ids = nil)
    @endpoint = endpoint
    @package_ids = package_ids # TODO: !!! No need endpoint.packages.pluck(:id), it's in a query. Write test, though.
  end

  def call
    return [] if @package_ids.size.zero?

    columns = Dependency.column_names
    sql =
      <<-SQL.squish
        WITH RECURSIVE dependency_tree (#{columns.join(", ")}, level)
        AS (
          SELECT
            #{columns.join(", ")}, 0
          FROM dependencies
          WHERE id IN (
            SELECT
              dependencies.id
            FROM dependencies, packages, settings
            WHERE dependencies.package_id::text IN (#{@package_ids.map { |p| "'#{p}'" }.join(", ")})
            AND settings.package_id = dependencies.package_id
            AND settings.endpoint_id = '#{@endpoint.id}'
            AND packages.id = dependencies.package_id
            AND packages.blocked_at IS NULL
          )

          UNION ALL

          SELECT
            #{columns.map { |col| "dependencies.#{col}" }.join(", ")}, level + 1
          FROM dependencies, dependency_tree, packages
          WHERE dependencies.package_id = dependency_tree.dependent_package_id
          AND packages.id = dependencies.dependent_package_id
          AND dependencies.optional = FALSE
          AND packages.blocked_at IS NULL
          AND dependencies.package_id::text NOT IN (#{@package_ids.map { |p| "'#{p}'" }.join(", ")})
        )
        SELECT * FROM dependency_tree
      SQL

    Dependency.find_by_sql(sql.chomp) || []
  end
end
