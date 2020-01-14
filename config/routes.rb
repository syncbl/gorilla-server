Rails.application.routes.draw do

  devise_for :users, controllers: {sessions: 'auth/sessions'}
    #,skip: [:sessions] do
    #  get '/login': "devise/sessions#new", :as => :new_user_session
    #  post '/login': 'devise/sessions#create', :as => :user_session
    #  get '/logout': 'devise/sessions#destroy', :as => :destroy_user_session
    #  get "/register": "users/registrations#new", :as => :new_user_registration
    #end
  #devise_for :endpoints, controllers: {sessions: 'auth/sessions'}
  get 'user', to: 'users#show'

  resources :packages
  # TODO: Get only installed apps with updates
  # !!! It's better to update like Steam - only by date, allowing to recover files manually
  #post 'update', to: 'users#auth', constraints: lambda { |req| req.format == :json }
  #get 'package(/:id)', to: 'packages#show'

  # TODO: only: []
  resources :parts, constraints: lambda { |req| req.format == :json }
  resources :endpoints, constraints: lambda { |req| req.format == :json }
  resources :settings, constraints: lambda { |req| req.format == :json }

  # TODO: Render commands like INSTALL, UNINSTALL, UPDATE etc.

  # TODO: Dashboard, endpoints and user settings only
  authenticated :user do
    root to: 'packages#index', as: :authenticated_root #'users#dashboard'
  end
  root to: redirect('/users/sign_in')

  #namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  #  list of resources
  #end

end
