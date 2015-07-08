Rails.application.routes.draw do
  root to: 'visitors#index'

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :routes, only: :index do
        get :get_route, on: :collection
      end
      #resources :routes, :only => [:index]
      # scope '/routes/:map_name' do
      #   get '/' => 'routes#get_route'
      # end
    end
  end
end
