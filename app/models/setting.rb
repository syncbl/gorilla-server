class Setting < ApplicationRecord
  belongs_to :package
  belongs_to :endpoint, touch: true
end
