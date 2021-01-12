Rails
  .application
  .routes
  .draw do
    devise_for :users,
               controllers: {
                 sessions: 'auth/sessions',
                 registrations: 'auth/registrations'
               }

    # TODO: Remove html declaration for api-only controllers

    resources :packages
    resource :endpoint, only: %i[show update destroy] do
      collection do
        post :install
        get :settings
      end
    end
    resources :endpoints, only: %i[index create] do
      member { post :install }
    end

    # We assuming that endpoint is set by token
    # TODO: get and update
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

    # This routes is only for non-API GET requests and must be in the end of route list

    get ':user_id/:id', to: 'packages#show'
    get ':id', to: 'packages#show'
    match '*path', to: 'packages#show', via: [:get, :post]
  end
