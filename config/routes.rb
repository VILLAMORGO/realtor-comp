Rails.application.routes.draw do
  get 'about_page/index'
  get 'support/index'

  post '/stripe/webhook', to: 'stripe_webhooks#create'

  # Define custom controller for Devise registrations
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    resources :users, only: [:new, :create]
    resources :bulk_uploads, only: [:new, :create, :index]
  end

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    member do
      delete :remove_profile_picture # Custom route to remove the profile picture
    end
  end

  resources :pending_requests, only: [:index, :update]
  resources :declined_requests, only: [:index, :destroy]
  resources :listings, only: [:index, :create, :edit, :update, :destroy, :new, :show] do
    patch :toggle_active, on: :member
  end

  resources :subscriptions, only: [:index, :new, :create] do
    collection do
      post :create_checkout_session
    end
  end

  authenticated :user, lambda { |u| u.admin? } do
    root 'users#index', as: :authenticated_admin_root
  end

  authenticated :user do
    root 'listings#index', as: :authenticated_user_root
  end

  root 'listings#index' # Default root if no user is logged in
end