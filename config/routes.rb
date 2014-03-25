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
      match '/stats/pocket_auth', to: 'stats#pocket_auth', via: 'get'
      match '/stats/pocket_middle', to: 'stats#pocket_middle', via: 'get'
      match '/stats/pocket_list', to: 'stats#pocket_list', via: 'get'
      match '/stats/youtube', to: 'stats#youtube', via: 'get'
      match '/stats/khan_auth', to: 'stats#khan_auth', via: 'get'
      
      # resources :conversations, only: [:create, :destroy, :index]
      # match '/conversations/notebook', to: 'conversations#notebook', via: 'get'
    end
  end 
end
