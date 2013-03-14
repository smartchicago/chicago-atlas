ChicagoAtlas::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  match 'condition/:slug' => 'dataset#show'
  get "conditions" => 'dataset#index'

  match 'place/:slug' => 'geography#show'
  get "places" => 'geography#index'

  get "about" => 'home#about'
  get "leaflet_test" => 'home#leaflet_test'

  match 'leaflet_community_areas(/:dataset_id/:year)' => 'home#leaflet_community_areas'

  root :to => 'home#index'

end
