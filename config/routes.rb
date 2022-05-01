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
      get :search
    end
  end
  # TODO: current_endpoint only for single term
  resource :endpoint, only: %i[show update] do
    resources :settings
    collection do
      post :clone
    end
  end
  resources :endpoints, only: %i[index create destroy] do
    resources :settings, only: %i[create]
  end

  authenticated :user do
    root to: "packages#index", as: :authenticated_root
  end
  root to: "packages#index" # TODO: products#landing?

  # namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  #  list of resources
  # end

  # This routes is only for non-API GET requests and must be in the end of route list

  resource :user, only: %i[show edit update]
  get ":user_id/:package_id", to: "packages#show"
  get ":id", to: "users#show"
  # match '*path', to: 'packages#show', via: [:get, :post]
end
