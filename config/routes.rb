Rails.application.routes.draw do

  resources :companies
  devise_for :users, controllers: {sessions: 'users/sessions'}
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
