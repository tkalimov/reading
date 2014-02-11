AlphaApi::Application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      root  'surveys#index'
      resources :surveys
      devise_for :users
      match '/users', to: 'users#index', via: 'get'
      match '/users/:id', to: 'users#show', via: 'get'
      match '/users/:id', to: 'users#destroy', via: 'delete'
      match '/users/:id', to: 'users#update', via: 'put'
      resources :conversations, only: [:create, :destroy, :index]
    end
  end 
	  
end
