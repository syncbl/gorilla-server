module ParamAwareable
  extend ActiveSupport::Concern

  def add_params_link(type, source, destination)
    raise :params, :link_not_exists unless Pathname.new(source).relative? &&
                                           available_files.include?(destination)

    add_params_value(type, source, destination)
  end

  def add_params_requirement(type, condition)
    add_params_value(:requirements, type, condition)
  end

  private

  def add_params_value(key, subkey, value)
    params[key] = {} if params[key].nil?
    params[key][subkey] = value
  end
end
