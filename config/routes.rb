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

    resources :packages do
      resources :sources
    end
    resource :endpoint, only: %i[show update destroy] do
      collection do
        post :install
      end
    end
    resources :endpoints, only: %i[index create] do
      member do
        post :install
      end
    end

    # Settings is for installers only
    resources :settings, only: [:index]

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
    get ':id', to: 'users#show'
    #match '*path', to: 'packages#show', via: [:get, :post]
  end
