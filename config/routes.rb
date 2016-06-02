Rails.application.routes.draw do
  resources :rounds do
    resources :types
  end
  resources :matches
  resources :teams
  resources :types

  devise_for :users
  root to: 'matches#index'

  get 'users/:id/types' => 'types#index'
  get 'users/:id/types/prepare' => 'types#prepare', as: :prepare_types



end
