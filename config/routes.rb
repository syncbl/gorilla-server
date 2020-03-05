Rails.application.routes.draw do

  devise_for :users, controllers: {sessions: 'auth/sessions', registrations: 'auth/registrations'}

  # TODO: Get only installed apps with updates
  # !!! It's better to update like Steam - only by date, allowing to recover files manually
  #post 'update', to: 'users#auth', constraints: lambda { |req| req.format == :json }
  #get 'package(/:id)', to: 'packages#show'

  # TODO: Remove html declaration for api-only controllers

  # TODO: Render commands like INSTALL, UNINSTALL, UPDATE etc. on packages
  # and disallow direct access to endpoints and settings

  resources :packages do
    member do
      put 'install', to: 'packages#install'
      put 'uninstall', to: 'packages#uninstall'
    end
  end
  resource :endpoint, only: [:show, :update]
  resources :endpoints, only: [:index]
  resources :settings, only: [:index, :show]
  resource :user, only: [:show]

  # TODO: Dashboard, endpoints and user settings only
  authenticated :user do
    root to: 'packages#index', as: :authenticated_root #'users#dashboard'
  end
  root to: redirect('/users/sign_in') #'users#landing'

  #namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  #  list of resources
  #end

end
