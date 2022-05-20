Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  namespace :webhooks do
    resources :bookings, only: [:create]
  end
end
