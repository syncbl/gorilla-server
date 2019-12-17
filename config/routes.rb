Rails.application.routes.draw do

  devise_for :users, controllers: {sessions: 'auth/sessions'}
  #devise_for :endpoints, controllers: {sessions: 'auth/sessions'}
  root 'packages#index'

  resources :packages
  resources :settings
  resources :parts
  resources :endpoints

  # No API for users, user data will be sent within login answer
  resources :users, only: [:show, :edit, :update]

  get '/release.json', constraints: lambda { |req| req.format == :json }, to: 'users#release'

  #namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  #  list of resources
  #end

end
