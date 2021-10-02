Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: "auth/sessions",
               registrations: "auth/registrations",
             }

  # TODO: Remove html declaration for api-only controllers

  resources :packages do
    resources :categories
    resources :sources do
      collection do
        post :merge
      end
    end
    collection do
      post :search
    end
  end
  resource :endpoint, only: %i[show update] do
    resources :settings
  end
  resources :endpoints, only: %i[index create destroy] do
    resources :settings, only: %i[create]
  end

  authenticated :user do
    root to: "packages#index", as: :authenticated_root
  end
  root to: "packages#index" # TODO: products#landing?

  #namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  #  list of resources
  #end

  # This routes is only for non-API GET requests and must be in the end of route list

  get :user, to: "users#profile"
  get ":user_id/:id", to: "packages#show"
  get ":id", to: "users#show"
  #match '*path', to: 'packages#show', via: [:get, :post]
end
