AlphaApi::Application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      root  'surveys#index'
      resources :surveys
      resources :users
    end
  end 
  
end
