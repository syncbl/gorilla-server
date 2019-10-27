Rails.application.routes.draw do

  root 'products#index'

  resources :products
  resources :settings
  resources :users
  resources :parts
  resources :packages
  resources :endpoints

#  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    # list of resources
#  end

end
