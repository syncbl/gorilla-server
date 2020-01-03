Rails.application.routes.draw do

  devise_for :users, controllers: {sessions: 'auth/sessions'}
  #devise_for :endpoints, controllers: {sessions: 'auth/sessions'}

  resources :packages
  #resources :settings, constraints: lambda { |req| req.format == :json }
  # Touch endpoint after update
  resources :endpoints, constraints: lambda { |req| req.format == :json }
  get 'user', to: 'users#show'
  #post 'update', to: 'users#auth', constraints: lambda { |req| req.format == :json }

  # TODO: Dashboard, endpoints and user settings only
  authenticated :user do
    root to: 'packages#index', as: :authenticated_root #'users#dashboard'
  end
  root to: redirect('/users/sign_in')

  #namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  #  list of resources
  #end

end
