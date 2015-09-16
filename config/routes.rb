Rails.application.routes.draw do

  root 'sessions#new'

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create]
  resources :home, only: [:index]
end
