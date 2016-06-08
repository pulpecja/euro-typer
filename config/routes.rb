Rails.application.routes.draw do

  resources :rounds do
    resources :types
  end
  resources :matches
  resources :teams
  resources :types

  devise_for :users
  resources :users, only: [:index, :show]
  root to: 'matches#index'

  get 'users/:id/types' => 'types#index'
  get 'users/:id/types/prepare' => 'types#prepare', as: :prepare_types
  get '/pages/index' => 'pages#index', as: :rules

  namespace 'admin' do
    root to: 'users#index'
    resources :users
    resources :matches
    resources :rounds
    resources :teams
    get 'become/:id', action: 'become'
  end


end
