class Package < ApplicationRecord
  include Discard::Model

  has_many :parts, dependent: :delete_all
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
