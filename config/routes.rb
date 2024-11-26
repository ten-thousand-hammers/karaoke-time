Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  get "search" => "search#index"
  post "search" => "search#index"
  post "play" => "search#play"
  
  get "splash" => "splash#index"

  post "skip" => "home#skip"
  get "qrcode" => "home#qrcode"

  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
  get '/auth/logout' => 'auth0#logout'
  get '/auth/redirect' => 'auth0#redirect'

  resources :profile, only: [:edit, :update]
  resources :browse, only: [:index]
  resources :songs do
    member do
      post :mark_file_problem
      post :mark_not_embeddable
    end
  end
end
