Rails.application.routes.draw do
  get 'notices/index'
  root 'home_pages#home'
  resources :users ,only: [:new,:create,:show,:edit,:update,:destroy] do
    collection do
      get 'followed'
      get 'follower'
    end
  end
  resources :notices, only: :index
  resources :account_activations, only: [:edit]
  resources :relationships, only:[:create,:destroy]
  resources :password_resets, only:[:new,:create,:edit,:update]
  resources :questions do
    resources :likes, only:[:create,:destroy]
    resources :comments do
      #質問の解決（solvedフラグの更新につかう
      post 'solved', on: :collection
    end
  end
  get '/help', to: 'home_pages#help'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
