AlphaApi::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :surveys
      resources :users
    end
  end 
  
end
