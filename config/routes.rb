Rails.application.routes.draw do

  devise_for :users, controllers: {sessions: 'users/sessions'}
  root 'products#index'

  resources :companies
  resources :products
  resources :packages
  resources :settings
  resources :users
  resources :parts
  resources :endpoints

#  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    # list of resources
#  end

end
