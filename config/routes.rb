Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create] do
    member do
      get :followings
      get :followers
    end
    
    member do
      get :likes
    end
  end
  
  resources :posts, only: [:show, :create, :destroy] do
    resources :comments, only: [:create, :destroy]
  end
    
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
  
  get 'messages', to: "messages#index", as: :messages_index
  get 'messages/:partner_id', to: 'messages#show', as: :message
  resources :messages, only: [:create, :destroy]
end
