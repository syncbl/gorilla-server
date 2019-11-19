class User < ApplicationRecord
  include Discard::Model

  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable

  has_many :packages, dependent: :destroy
  has_many :endpoints
  belongs_to :user, optional: true

  default_scope -> {
    kept
  }
end
