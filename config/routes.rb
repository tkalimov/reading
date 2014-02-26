AlphaApi::Application.routes.draw do  
  get "businesses/find"
  namespace :api do
    namespace :v1 do
      root  'surveys#index'
      resources :surveys, only: [:create, :destroy, :index, :update, :show]
      resources :businesses, only: [:create, :destroy, :index]
      devise_for :users, :controllers => { :omniauth_callbacks => "api/v1/omniauth_callbacks" } 
      match '/users', to: 'users#index', via: 'get'
      match '/users/:id', to: 'users#show', via: 'get'
      match '/users/:id', to: 'users#destroy', via: 'delete'
      match '/users/:id', to: 'users#update', via: 'put'
      match '/auth/:provider/callback', to: 'sessions#create', via: 'get'
      resources :conversations, only: [:create, :destroy, :index]
      match '/businesses/find', to: 'businesses#find', via: 'get'
    end
  end 
end
