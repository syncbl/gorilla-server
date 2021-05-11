class User < ApplicationRecord
  include Blockable
  has_friendship

  # Include default devise modules. Others available are:
  # :rememberable, :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :timeoutable,
         :validatable

  has_secure_token :authentication_token
  attr_accessor :token

  # Because of company support and installed packages we can't allow to delete resources
  # has_many (as on Git) OR belongs_to :w, optional: true
  has_many :packages, dependent: :destroy
  has_many :endpoints, dependent: :destroy
  has_and_belongs_to_many :maintained,
                          class_name: "Package",
                          join_table: :maintainers,
                          association_foreign_key: :package_id,
                          dependent: :destroy

  validates :name,
            name_restrict: true,
            presence: true,
            length: { minimum: MIN_NAME_LENGTH, maximum: MAX_NAME_LENGTH },
            uniqueness: { case_sensitive: false },
            format: { with: NAME_FORMAT }
  validates :fullname,
            length: { maximum: MAX_NAME_LENGTH }
  validates :authentication_token,
            allow_nil: true, # To allow token auto generation
            length: { is: 24 }

  # TODO: Everyone can create packages, but we need to add permissions for company members later

  before_validation :generate_name

  def active_for_authentication?
    super && !self.blocked?
  end

  def authenticatable_salt
    "#{super}#{authentication_token}"
  end

  def inactive_message
    !self.blocked? ? super : :blocked
  end

  def friendly?(object)
    friends.include?(object.user) && object.published?
  end

  def can_view?(object)
    can_edit?(object) || friendly?(object) || object.product.present?
  end

  def can_edit?(object)
    is_owner?(object) || maintained.include?(object)
  end

  private

  def is_owner?(object)
    object.user == self
  end

  def generate_name
    if name.blank?
      name = "#{self.email[/^[^@]+/]}"
      self.name = User.find_by(name: name).nil? ? name : "#{name}#{rand(10_000)}"
    end
    self.name.downcase!
  end
end
