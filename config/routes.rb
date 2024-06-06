Rails.application.routes.draw do
  get 'home', to: 'home#index'
  
  # Define custom controller for Devise registrations
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end