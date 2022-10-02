Rails.application.routes.draw do 
  get 'password_resets/new'
  get 'password_resets/edit'
  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  # get    :favorites, to: 'favorites#index'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  post   "favorites/:micropost_id/create"  => "favorites#create"
  delete "favorites/:micropost_id/destroy" => "favorites#destroy"
  resources :users do
    member do
      get :following, :followers, :favorites
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:new, :create, :destroy, :show]
  resources :relationships,       only: [:create, :destroy]
end