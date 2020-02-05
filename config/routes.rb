Rails.application.routes.draw do

  resources :services
  resources :companies
  devise_for :users, controllers: {sessions: 'auth/sessions', registrations: 'auth/registrations'}
    #,skip: [:sessions] do
    #  get '/login': "devise/sessions#new", :as => :new_user_session
    #  post '/login': 'devise/sessions#create', :as => :user_session
    #  get '/logout': 'devise/sessions#destroy', :as => :destroy_user_session
    #  get "/register": "users/registrations#new", :as => :new_user_registration
    #end
  #devise_for :endpoints, controllers: {sessions: 'auth/sessions'}

  resources :packages
  # TODO: Get only installed apps with updates
  # !!! It's better to update like Steam - only by date, allowing to recover files manually
  #post 'update', to: 'users#auth', constraints: lambda { |req| req.format == :json }
  #get 'package(/:id)', to: 'packages#show'

  # TODO: Remove html declaration for api-only controllers

  # TODO: Render commands like INSTALL, UNINSTALL, UPDATE etc. on packages
  # and disallow direct access to endpoints and settings

  # TODO: Dashboard, endpoints and user settings only
  authenticated :user do
    root to: 'packages#index', as: :authenticated_root #'users#dashboard'
    get 'user', to: 'users#show'
    constraints format: :json do
      get 'endpoint', to: 'endpoints#show'
      put 'endpoint', to: 'endpoints#update'
      resources :endpoints, only: [:index]
      resources :settings, only: [:show, :update]
    end
  end
  root to: redirect('/users/sign_in')

  #namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  #  list of resources
  #end

end
