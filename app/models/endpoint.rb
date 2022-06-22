class Endpoint < ApplicationRecord
  include Blockable
  include Notifiable
  include TokenResetable

  # attribute :locale, :string, default: "en"

  belongs_to :user, optional: true
  has_many :settings, dependent: :destroy
  has_many :packages, through: :settings
  # TODO: Noticed has_many :notifications, as: :recipient, dependent: :destroy

  validates :caption, length: { maximum: MAX_NAME_LENGTH }
  validates :locale, length: { maximum: 10 }

  def installed?(package)
    settings.exists?(package:)
  end

  def install(packages)
    return [] unless packages.any?

    settings = Set[]
    Setting.transaction do
      packages.each do |package|
        settings << PackageInstallService.call(self, package)
      end
    rescue ActiveRecord::RecordInvalid => e
      errors.add :packages, e.message
      settings.clear
      raise ActiveRecord::Rollback
    end
    settings
  end
end
