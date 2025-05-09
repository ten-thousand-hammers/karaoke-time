Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  get "search" => "search#index"
  post "search" => "search#index"
  post "play" => "search#play"

  get "splash" => "splash#index"

  post "skip" => "home#skip"
  post "next_song", to: "home#next_song"
  post "prev_song", to: "home#prev_song"
  post "pause_song", to: "home#pause_song"

  get "qrcode" => "home#qrcode"

  resources :profile, only: [:edit, :update]
  resources :browse, only: [:index]
  resources :songs do
    member do
      post :mark_file_problem
      post :mark_not_embeddable
    end
  end

  get "settings" => "settings#index"
  patch "settings" => "settings#update"
  post "settings/update_yt_dlp" => "settings#update_yt_dlp"
  resource :settings, only: [:index, :update] do
    get :index, on: :collection
  end
end
