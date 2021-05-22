class Maintain < ApplicationRecord
  belongs_to :package
  belongs_to :user

  validates :user, package_maintain: true
end
