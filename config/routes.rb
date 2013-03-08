ChicagoAtlas::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  match 'condition/:slug' => 'dataset#show'
  get "conditions" => 'dataset#index'

  match 'place/:slug' => 'geography#show'
  get "places" => 'geography#index'

  get "map" => 'home#map'
  get "about" => 'home#about'
  get "leaflet_test" => 'home#leaflet_test'
  get "leaflet_community_areas" => 'home#leaflet_community_areas'

  root :to => 'home#index'

end
