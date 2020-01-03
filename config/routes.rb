Rails.application.routes.draw do

  devise_for :users, controllers: {sessions: 'auth/sessions'}
  #devise_for :endpoints, controllers: {sessions: 'auth/sessions'}

  resources :packages
  resources :settings, constraints: lambda { |req| req.format == :json }
  #resources :parts
  resources :endpoints, constraints: lambda { |req| req.format == :json }
  resources :users, only: [:show, :edit]
  get 'user', to: 'users#show'
  post 'user', to: 'users#auth'

  # TODO: Dashboard, endpoints and user settings only
  authenticated :user do
    root to: 'packages#index', as: :authenticated_root #'users#dashboard'
  end
  root to: redirect('/users/sign_in')

  #namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  #  list of resources
  #end

end
