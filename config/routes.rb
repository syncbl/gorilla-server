Rails.application.routes.draw do

  devise_for :users, controllers: {sessions: 'auth/sessions', registrations: 'auth/registrations'}

  # TODO: Remove html declaration for api-only controllers

  resources :packages
  resource :endpoint, only: [:show, :update, :destroy] do
    collection do
      post :install
      get :settings
    end
  end
  resources :endpoints, only: [:index, :create] do
    member do
      post :install
    end
  end
  resources :settings, only: [:index]
  resource :user, only: [:show]

  # TODO: Dashboard, endpoints and user settings only
  authenticated :user do
    root to: 'packages#index', as: :authenticated_root #'users#dashboard'
  end
  root to: 'packages#index' #redirect('/users/sign_in') #'users#landing'

  #namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  #  list of resources
  #end

end
