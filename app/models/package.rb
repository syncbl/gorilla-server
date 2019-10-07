class Package < ApplicationRecord
  include Discard::Model

  has_many :parts, dependent: :destroy
  has_and_belongs_to_many :endpoints
  belongs_to :user, optional: true
  after_create :create_main_part

  scope :available_for, -> (user) {
    where(user: user)
    .or(where(user: nil, trusted: true))
  }

  def to_yaml
    #
  end

  private

  def create_main_part
    parts.create(
      name: 'main'
    )
  end
end
