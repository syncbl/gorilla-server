module SimpleTypeable
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval do
      validate :check_type
    end
  end

  def package_type
    type.split('::')[1].downcase.to_sym
  end

  def bundle?
    type == "Package::Bundle"
  end

  def component?
    type == "Package::Component"
  end

  def external?
    type == "Package::External"
  end

  private

  def check_type
    bundle? || component? || external?
  end
end
