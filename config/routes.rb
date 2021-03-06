Rails.application.routes.draw do
  resources :groups
  root to: 'competitions#show'

  resources :competitions

  resources :groups do
    resources :competitions do
      resources :matches
    end
    get '/join/:token' => 'groups#join', as: :join_group
  end

  resources :rounds do
    resources :types
  end
  resources :matches
  resources :teams
  resources :types
  resources :winner_types

  devise_for :users
  resources :users, only: [:show] do
    get '/join_competition/:competition_id' => 'users#join_competition', as: :join_competition
  end

  get 'users/:id/types' => 'types#index'
  get 'users/:id/types/prepare' => 'types#prepare', as: :prepare_types
  get '/pages/index' => 'pages#index', as: :rules
  get 'competitions' => 'competitions#index'
  get 'groups' => 'groups#show'

  namespace 'admin' do
    root to: 'users#index'
    resources :users
    resources :matches
    resources :rounds
    resources :teams
    resources :competitions
    resources :groups
    resources :settings
    get 'become/:id', action: 'become'
  end


end
