Rails.application.routes.draw do
  root to: 'visitors#index'

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :routes, only: :index do
        get  :get_route, on: :collection
        post :create_map, on: :collection
      end
    end
  end
end
