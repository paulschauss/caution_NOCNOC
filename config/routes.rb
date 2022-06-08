Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :bookings, only: [:index, :show] do
    resources :cautions
  end
  resources :cautions, only: [:destroy]

  resources :hold, only: [:create]

  namespace :webhooks do
    resources :bookings, only: [:create]
  end
end
