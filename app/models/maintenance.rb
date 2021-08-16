class Maintenance < ApplicationRecord
  belongs_to :package
  belongs_to :user

  validates :user, package_maintainer: true
end
