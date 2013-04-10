ChicagoAtlas::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # primary routes
  match 'condition/:slug' => 'dataset#show'
  get "conditions" => 'dataset#index'

  match 'place/:slug' => 'geography#show'
  get "places" => 'geography#index'

  match 'place/:geo_slug/:dataset_slug' => 'geography#showdataset'

  # static pages
  match 'map(/:dataset_slug)' => 'home#map'
  get "about" => 'home#about'
  get "partners" => 'home#partners'
  get "partner_sign_up" => 'home#partner_sign_up'

  # test pages
  get "leaflet_test" => 'home#leaflet_test'
  get "interventions_test" => 'home#interventions_test'

  root :to => 'home#index'

end
