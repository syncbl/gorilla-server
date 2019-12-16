Rails.application.routes.draw do

  devise_for :users, controllers: {sessions: 'users/sessions'}
  root 'packages#index'

  resources :packages
  resources :settings
  resources :parts
  resources :endpoints

  # No API for users, user data will be sent within login answer
  resources :users, only: [:show, :edit, :update]

  get '/release.json', constraints: lambda { |req| req.format == :json }, to: 'packages#release'

  #defaults format: :json, constraints: lambda { |req| req.format == :json } do
  #  get '/release', constraints: lambda { |req| req.format == :json }, to: 'products#release'
  #end
  #namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  #  list of resources
  #end

end
