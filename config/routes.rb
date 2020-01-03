Rails.application.routes.draw do

  devise_for :users, controllers: {sessions: 'auth/sessions'}
  #devise_for :endpoints, controllers: {sessions: 'auth/sessions'}

  resources :packages
  resources :settings
  resources :parts
  resources :endpoints
  resources :users, only: [:show, :edit]
  get 'user', to: 'users#show'

  authenticated :user do
    root to: 'packages#index', as: :authenticated_root #'users#dashboard'
  end
  root to: redirect('/users/sign_in')

  get '/release.json', constraints: lambda { |req| req.format == :json }, to: 'users#release'

  #namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  #  list of resources
  #end

end
