Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :bookings, only: [:index, :show]

  namespace :webhooks do
    resources :bookings, only: [:create]
  end
end
