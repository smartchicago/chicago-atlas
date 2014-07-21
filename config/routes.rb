ChicagoAtlas::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # primary routes
  match 'place/:slug' => 'geography#show'
  get "places" => 'geography#index'
  match 'place/causesofdeath/:geo_slug' => 'geography#show_death_dataset'
  match 'place/demographic/:geo_slug' => 'geography#show_demographic_dataset'
  match 'place/insurance/:cat_name/:geo_slug' => 'geography#show_insurance_dataset'
  match 'place/providers/:geo_slug' => 'geography#show_provider_dataset'
  match 'place/:geo_slug/resources(/:dataset_slug)' => 'geography#show_resources'
  match 'place/:geo_slug/:dataset_slug' => 'geography#show_dataset'
  get "hospital/index"
  match 'hospital/:slug' => 'hospital#show'

  # static
  match 'map(/:dataset_slug)' => 'home#map'
  get "about" => 'home#about'
  get "partners" => 'home#partners'
  get "partner_sign_up" => 'home#partner_sign_up'

  # json
  match "resources(/:dataset_id)/:north/:east/:south/:west" => 'geography#resources_json'
  match "resources(/:dataset_id)/:community_area_slug" => 'geography#resources_json'

  # errors
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end

  # root
  root :to => 'home#index'

end
