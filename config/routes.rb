AlphaApi::Application.routes.draw do  
  root  'home#index'
  namespace :api do
    namespace :v1 do
      devise_for :users, :controllers => { :omniauth_callbacks => "api/v1/omniauth_callbacks" } 
      match '/users', to: 'users#index', via: 'get'
      match '/users/:id', to: 'users#show', via: 'get'
      match '/users/:id', to: 'users#destroy', via: 'delete'
      match '/users/:id', to: 'users#update', via: 'put'
      match '/auth/:provider/callback', to: 'sessions#create', via: 'get'
      match '/pocket/pocket_start', to: 'users#pocket_start', via: 'get'
      match '/pocket/pocket_middle', to: 'users#pocket_middle', via: 'get'
      match '/pocket/pocket_list', to: 'users#pocket_list', via: 'get'
      
      # resources :conversations, only: [:create, :destroy, :index]
      # match '/conversations/notebook', to: 'conversations#notebook', via: 'get'
    end
    root to: "home#index"
  end 
end
