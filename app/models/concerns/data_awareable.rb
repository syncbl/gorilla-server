module DataAwareable
  extend ActiveSupport::Concern

  def add_data_link(source, destination)
    add_data_value(:links, source, destination) if filelist.include?(source)
  end

  def add_data_requirement(type, condition)
    add_data_value(:requirements, type, condition)
  end

  private

  def add_data_value(key, subkey, value)
    self.data[key] = {} if self.data[key].nil?
    self.data[key][subkey] = value
  end
end
