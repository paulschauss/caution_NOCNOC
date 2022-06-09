Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :bookings, only: %i[index show]

  resources :cautions, only: %i[index show]

  resources :hold, only: [:create]

  namespace :webhooks do
    resources :bookings, only: [:create]
  end
end
