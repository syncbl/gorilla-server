class PublishedPackagesService < ApplicationService
  def initialize(user = nil, packages = Package.all)
    @user = user
    @packages = packages
  end

  def call
    @packages.where(Package.arel_table[:published_at].lt(Time.current))
      .or(@packages.where(user: @user))
  end
end
