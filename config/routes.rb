Rails.application.routes.draw do
  root 'home_pages#home'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only:[:new,:create,:edit,:update]
  resources :questions do
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
