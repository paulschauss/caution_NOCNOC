Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :bookings, only: [:index, :show]
  resources :cautions
  resources :hold, only: [:create]

  namespace :webhooks do
    resources :bookings, only: [:create]
  end
end
