ChicagoAtlas::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  match 'dataset/:slug' => 'dataset#show'
  get "dataset" => 'dataset#index'

  match 'geography/:slug' => 'geography#show'
  get "geography" => 'geography#index'

  get "map" => 'home#map'
  get "about" => 'home#about'

  root :to => 'home#index'

end
