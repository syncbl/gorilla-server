module Findable
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval do
      def self.find_any!(value)
        where(id: value).or(where(name: value)).first!
      end
    end
  end
end