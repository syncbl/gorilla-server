module ResponseHelper
  def call(method, *args)
    send(method, *args).with_indifferent_access
  end
end
