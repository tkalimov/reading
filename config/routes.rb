AlphaApi::Application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      root  'surveys#index'
      resources :surveys
      devise_for :users
      match '/users', to: 'users#index', via: 'get'
      match '/users/:id', to: 'users#show', via: 'get'
    end
  end 
  devise_for :users
  
end
