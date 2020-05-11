class Setting < ApplicationRecord
  include Discard::Model

  self.implicit_order_column = :updated_at

  before_save :check_package

  belongs_to :package
  belongs_to :endpoint #, touch: true
  validates :package_id, uniqueness: { case_sensitive: false, scope: :endpoint_id }

  private

  def check_package
    (endpoint.user == package.user) || package.trusted
  end

end
