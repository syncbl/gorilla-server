Rails.application.routes.draw do

  resources :companies
  devise_for :users, controllers: {sessions: 'users/sessions'}
  root 'products#index'

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
