Rails.application.routes.draw do
  get 'about_page/index'
  get 'support/index'

  post '/stripe/webhook', to: 'stripe_webhooks#create'

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    resources :users, only: [:new, :create]
    resources :bulk_uploads, only: [:new, :create, :index]
  end

  namespace :broker do
    resources :users, only: [:index]
  end

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    member do
      delete :remove_profile_picture
    end
    collection do
      get :search
    end
  end

  resources :pending_requests, only: [:index, :update, :destroy]
  resources :declined_requests, only: [:index, :destroy]
  resources :listings, only: [:index, :new, :create, :edit, :update, :destroy, :show] do
    patch :toggle_active, on: :member
  end

  resources :subscriptions, only: [:index, :new, :create] do
    collection do
      post :create_checkout_session
    end
  end

  resources :conversations do
    resources :messages, only: [:create]
  end

  authenticated :user, ->(u) { u.admin? } do
    root 'users#index', as: :authenticated_admin_root
  end

  authenticated :user do
    root 'listings#index', as: :authenticated_user_root
  end

  root 'listings#index'
end