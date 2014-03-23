AlphaApi::Application.routes.draw do  
  namespace :api do
    namespace :v1 do
      root  'surveys#index'
      resources :surveys, only: [:create, :destroy, :index, :update]
      devise_for :users, :controllers => { :omniauth_callbacks => "api/v1/omniauth_callbacks" } 
      match '/users', to: 'users#index', via: 'get'
      match '/users/:id', to: 'users#show', via: 'get'
      match '/users/:id', to: 'users#destroy', via: 'delete'
      match '/users/:id', to: 'users#update', via: 'put'
      match '/auth/:provider/callback', to: 'sessions#create', via: 'get'
      resources :conversations, only: [:create, :destroy, :index]
      match '/businesses/find_business', to: 'users#find_business', via: 'get'
      match '/businesses/create_business', to: 'users#create_business', via: 'post'
      match '/surveys/admin_survey', to: 'surveys#admin_survey', via: 'post'
      match '/surveys/results', to: 'surveys#results', via: 'get'
      match '/conversations/notebook', to: 'conversations#notebook', via: 'get'
      match '/pocket/pocket_start', to: 'users#pocket_start', via: 'get'
      match '/pocket/pocket_middle', to: 'users#pocket_middle', via: 'get'
      match '/pocket/pocket_list', to: 'users#pocket_list', via: 'get'
    end
  end 
end
