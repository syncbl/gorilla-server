module ParamAwareable
  extend ActiveSupport::Concern

  def add_params_link(source, destination)
    if available_files.include?(source)
      add_params_value(:links, source, destination)
    else
      raise I18n.t("errors.messages.link_not_exists")
    end
  end

  def add_params_requirement(type, condition)
    add_params_value(:requirements, type, condition)
  end

  private

  def add_params_value(key, subkey, value)
    self.params[key] = {} if self.params[key].nil?
    self.params[key][subkey] = value
  end

  def self.included(base)
    base.class_eval {
      jsonb_accessor :params,
                     path: [:string, default: ""],
                     path_persistent: [:boolean, default: false],
                     require_administrator: [:boolean, default: false],
                     require_restart: [:boolean, default: false]
    }
  end
end
