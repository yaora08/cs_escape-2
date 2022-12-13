Rails.application.routes.draw do 
  get 'chats/show'
  get 'comments/create'
  get 'comments/destroy'
  get 'password_resets/new'
  get 'password_resets/edit'
  root   'static_pages#home' 
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/all_posts',    to: 'static_pages#all_posts'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  post   "favorites/:micropost_id/create"  => "favorites#create"
  delete "favorites/:micropost_id/destroy" => "favorites#destroy"
  resources :static_pages do
    member do
      get :all_posts
    end
  end
  get 'chat/:id', to: 'chats#show', as: 'chat'
  


  resources :users do
    member do
      get :following, :followers, :favorites
      resources :chats, only: [:create, :show]
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:new, :create, :destroy, :show] do
    resources :comments, only: [:create, :destroy, :new]
  end
  resources :relationships,       only: [:create, :destroy]
end