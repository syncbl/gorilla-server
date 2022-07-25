# TODO: Convert to class
class Response
  Rails.application.routes.default_url_options[:host] = ""

  def build(method, *args)
    send(method, *args).with_indifferent_access
  end
end
