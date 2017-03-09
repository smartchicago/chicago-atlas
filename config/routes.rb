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
      get '/place/insurance/:cat_id/:geo_slug', to: 'geographies#show_insurance_dataset', as: 'community_area_insurance'
      get '/place/providers/:geo_slug', to: 'geographies#show_provider_dataset', as: 'community_area_provider'
      get '/place/category/:cat_id/:geo_slug', to: 'geographies#show_category_dataset', as: 'community_area_category'
      get '/topics', to: 'topics#index', as: 'topics_list'
      get '/topic_city/:year/:indicator_slug', to: 'topics#city_show', as: 'topic_city_detail'
      get '/topic_area/:year/:indicator_id', to: 'topics#area_show', as: 'topic_community_area_detail'
      get '/topic_demo/:indicator_id/:demography', to: 'topics#demo', as: 'topic_detail_demography'
      get '/topic_detail/:indicator_id', to: 'topics#trend', as: 'topic_detailed_all'
      get '/topic_recent/:indicator_slug', to: 'topics#recent', as: 'topic_recent'
      get '/topic_info/:geo_slug/:indicator_id', to: 'topics#info', as: 'topic_info'
      get '/resources_category/:category_slug(/:dataset_slug)', to: 'geographies#resources_category', as: 'chicago_resources_category'
      get '/resources(/:dataset_id)/:north/:east/:south/:west' => 'geographies#resources_json'
      get '/resources(/:dataset_id)/:community_area_slug' => 'geographies#resources_json'
      get '/hospital/:slug', to: 'hospital#show', as: 'hospital_with_slug'
      get '/:geo_slug/hospitals', to: 'hospital#index', as: 'community_area_hospitals'
      get '/hospitals', to: 'hospital#hospitals_all', as: 'chicago_hospitals'
    end
  end
end
