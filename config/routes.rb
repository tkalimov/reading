AlphaApi::Application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      root  'surveys#index'
      resources :surveys
      devise_for :users
    end
  end 
  
end
