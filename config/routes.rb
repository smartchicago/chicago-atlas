Rails.application.routes.draw do
  resources :uploaders
  resources :resources

  authenticated :user do
    root to: 'uploaders#index', as: :authenticated_root
  end

  root to: redirect('/users/sign_in')

  devise_for :users

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :indicators, only: [:index, :show] do
      end

      # resources :geographies, only: [:index, :show] do
      # end
      get "/places", to: 'geographies#index', as: 'community_areas'
      get "/place/:geo_slug", to: 'geographies#show', as: 'community_area'
    end
  end
end
