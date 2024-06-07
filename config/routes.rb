Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "home#index"
  
  get 'home', to: 'home#index'
  
  # Define custom controller for Devise registrations
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :pending_requests, only: [:index, :update]
  resources :declined_requests, only: [:index, :destroy]
end