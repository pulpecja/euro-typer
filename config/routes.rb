Rails.application.routes.draw do
  resources :matches

  resources :teams

  devise_for :users
  root to: 'matches#index'

end
