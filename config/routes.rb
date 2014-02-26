AlphaApi::Application.routes.draw do  
  namespace :api do
    namespace :v1 do
      root  'surveys#index'
      resources :surveys, only: [:create, :destroy, :index, :update, :show]
      devise_for :users, :controllers => { :omniauth_callbacks => "api/v1/omniauth_callbacks" } 
      match '/users', to: 'users#index', via: 'get'
      match '/users/:id', to: 'users#show', via: 'get'
      match '/users/:id', to: 'users#destroy', via: 'delete'
      match '/users/:id', to: 'users#update', via: 'put'
      match '/auth/:provider/callback', to: 'sessions#create', via: 'get'
      resources :conversations, only: [:create, :destroy, :index]
      match '/businesses/find_business', to: 'users#find_business', via: 'get'
      match '/businesses/create_business', to: 'users#create_business', via: 'post'
    end
  end 
end
