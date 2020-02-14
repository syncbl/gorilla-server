class Endpoint < ApplicationRecord
  after_touch :actualize!

  has_secure_token :authentication_token

  belongs_to :user
  has_many :settings, dependent: :destroy
  has_many :packages, through: :settings

  validates :key, length: {is: 36}, allow_blank: true

  def actualize!
    all_packages = []
    settings.map { |s| s.package.all_dependencies(all_packages) }
    settings.where.not(package: all_packages).where.not(dependent: false).discard_all
    settings.map { |s| all_packages.delete(s.package) }
    all_packages.each { |p| settings.create(package: p, dependent: true) }
  end

  def to_param
    key
  end
end
