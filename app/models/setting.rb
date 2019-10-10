class Setting < ApplicationRecord
  include Discard::Model

  belongs_to :package
  belongs_to :endpoint
end
