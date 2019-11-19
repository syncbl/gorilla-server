class ApplicationController < ActionController::Base
  acts_as_token_authentication_handler_for User
  protect_from_forgery unless: -> { request.format.json? }
end
