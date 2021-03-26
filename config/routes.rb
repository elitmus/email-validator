require 'sidekiq/web'
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount Sidekiq::Web => "/sidekiq"
      resources :emails, only: [:create, :index]
      post "users/login", to: "users#login"
      post "users/check", to: "users#google_login"
      resources :users, only: [:create, :index, :update]
      resources :uploads, only: [:create, :index]
    end
  end
  root "home#index"
  get "/*path" => "home#index"
end
