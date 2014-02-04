AlphaApi::Application.routes.draw do
  resources :users, except: [:new, :edit]
  namespace :api do
    namespace :v1 do
      resources :surveys
    end
  end 
  
end
