class User < ApplicationRecord
  include Discard::Model
  after_discard do
    if company.nil?
      endpoints.discard_all
      packages.discard.all
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :timeoutable, :lockable

  # Because of company support and installed packages we can't allow to delete resources
  belongs_to :company, optional: true
  has_many :packages, dependent: :nullify
  has_many :endpoints, dependent: :nullify

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 105 },
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

  attr_accessor :endpoint
  attr_accessor :endpoint_new_token
  # TODO: Everyone can create packages, but we need to add permissions for company members later

  def readable_name
    name || email
  end

  def ready_for_authentication?
    blocked_at.nil? && discarded_at.nil?
  end

end
