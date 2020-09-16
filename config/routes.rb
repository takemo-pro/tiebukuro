Rails.application.routes.draw do
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only:[:new,:create,:edit,:update]
  resources :questions
  root 'home_pages#home'
  get '/help', to: 'home_pages#help'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
