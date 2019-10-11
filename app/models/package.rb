class Package < ApplicationRecord
  include Discard::Model
  acts_as_taggable

  has_many :parts, dependent: :destroy
  has_many :settings
  has_many :endpoints, through: :settings
  has_one :product
  has_and_belongs_to_many :requirements,
    class_name: "Package",
    join_table: :requirements,
    foreign_key: :package_id,
    association_foreign_key: :required_package_id
  belongs_to :user, optional: true
  after_create :create_main_part

  default_scope -> {
    kept. # ???
    order(user_id: :asc)
  }

  scope :available_for, -> (user = nil) {
    # TODO: Optimize with arel_table
    where(published: true, unstable: false)
    .where(user: user).or(where(user: nil))
  }

  scope :editable_by, -> (user = nil) {
    # TODO: Optimize with arel_table
    where(published: false)
    .where(user: user)
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
