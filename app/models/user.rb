class User < ApplicationRecord
  include Discard::Model

  # Include default devise modules. Others available are:
  # :validatable, :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :timeoutable, :lockable

  has_secure_token :authentication_token

  # Because of company support and installed packages we can't allow to delete resources
  # has_many (as on Git) OR belongs_to :group, optional: true
  has_many :packages, dependent: :nullify
  has_many :endpoints, dependent: :nullify

  after_discard do
    # if group.nil?
    endpoints.discard_all
    packages.discard_all
  end

  validates :email, presence: true, length: { maximum: 105 },
    uniqueness: { case_sensitive: false },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :alias, uniqueness: { case_sensitive: false }, allow_blank: true,
    format: { with: /\A[A-Za-z\d\-\_]*\z/ }

  attr_accessor :endpoint
  attr_accessor :endpoint_new_token

  # TODO: Everyone can create packages, but we need to add permissions for company members later

  def readable_name
    name || email
  end

end
