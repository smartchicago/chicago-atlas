ChicagoAtlas::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # primary routes
  match 'place/:slug' => 'geography#show'
  get "places" => 'geography#index'
  match 'place/:geo_slug/:dataset_slug' => 'geography#showdataset'

  # static
  match 'map(/:dataset_slug)' => 'home#map'
  get "about" => 'home#about'
  get "partners" => 'home#partners'
  get "partner_sign_up" => 'home#partner_sign_up'

  # json
  match "interventions/:north/:east/:south/:west" => 'dataset#interventions'

  # root
  root :to => 'home#index'

end
