Rails.application.routes.draw do

  devise_for :users, controllers: {sessions: 'users/sessions'}
  root 'products#index'

  resources :products
  resources :packages
  resources :settings
  resources :parts
  resources :endpoints

  # No API for users, user data will be sent within login answer
  resources :users, only: [:show, :edit, :update]

#  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    # list of resources
#  end

end
