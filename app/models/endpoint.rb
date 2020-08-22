class Endpoint < ApplicationRecord
  # TODO: Replace discard with state enum.
  include Discard::Model

  self.implicit_order_column = :created_at

  has_secure_token :authentication_token
  belongs_to :user
  has_many :settings
  has_many :packages, through: :settings
  has_and_belongs_to_many :packages,
   join_table: :settings,
   dependent: :destroy

  scope :actual, -> {
    where(Endpoint.arel_table[:updated_at]
      .gt(Time.current - Rails.application.config.endpoint_token_expiration_time))
  }

  # TODO: Redo, it doesn't working as supposed
  def actualize!
    discarded_packages = []
    installed_packages = []
    settings.where(dependent: false).map { |s|
      if s.discarded?
        s.package.all_dependencies(discarded_packages)
      else
        s.package.all_dependencies(installed_packages)
      end
    }
    discarded_packages.delete_if { |p|
      installed_packages.include?(p)
    }
    settings.kept.where(package: discarded_packages, dependent: true).discard_all
    settings.kept.map { |s|
      installed_packages.delete(s.package)
    }
    installed_packages.each {
      |p| settings.create(package: p, dependent: true)
    }
  end

  def block!(reason = nil)
    self.discarded_at = Time.current
    self.discard_reason = reason
    save!
  end

  def installed?(package)
    settings.exists?(package: package)
  end

  def install(package)
    settings.find_by(package: package)&.touch || packages << package
  end

end
