Rails.application.routes.draw do
  resources :types

  resources :matches

  resources :teams

  devise_for :users
  root to: 'matches#index'

  get 'users/:id/types' => 'types#index'

end
