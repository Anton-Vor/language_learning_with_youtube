Rails.application.routes.draw do
  devise_for :users
  resources :users
  root to: 'pages#home'
  resources :videos, only: [:show]
  resources :cards
  get '/how_to', to: 'pages#how_to'
end
