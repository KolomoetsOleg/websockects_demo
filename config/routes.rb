Rails.application.routes.draw do

  root 'sessions#new'

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  resources :chat, only: [:index] do
    get :new_posts, on: :collection
  end
end
