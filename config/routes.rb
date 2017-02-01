Rails.application.routes.draw do
  apipie
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

      get '/places', to: 'geographies#index', as: 'community_areas'
      get '/place/:geo_slug', to: 'geographies#show', as: 'community_area'
      get '/place/:geo_slug/resources(/:dataset_slug)', to: 'geographies#resources_json', as: 'community_area_resources'
      get '/place/demography/:geo_slug', to: 'geographies#show_demographic_dataset', as: 'community_area_demography'
      get '/place/insurance/:cat_name/:geo_slug', to: 'geographies#show_insurance_dataset', as: 'community_area_insurance'
      get '/place/providers/:geo_slug', to: 'geographies#show_provider_dataset', as: 'community_area_provider'
      get '/place/category/:cat_id/:geo_slug', to: 'geographies#show_category_dataset', as: 'community_area_category'
      get '/:geo_slug/hospitals', to: 'hospital#index', as: 'community_area_hospitals', as: 'hospitals'
      get '/hospital/:slug', to: 'hospital#show', as: 'hospital_with_slug', as: 'hopital_details'
      get '/topics', to: 'topics#index', as: 'topics_list', as: 'topics'
    end
  end
end
