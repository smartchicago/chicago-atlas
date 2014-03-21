ChicagoAtlas::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # redirects
  get 'map/:dataset_slug', to: redirect('/conditions/%{dataset_slug}')
  get 'map', to: redirect('/conditions')

  # primary routes
  match 'place/:slug' => 'geography#show'
  get "places" => 'geography#index'
  match 'place/:geo_slug/resources(/:dataset_slug)' => 'geography#show_resources'
  match 'place/:geo_slug/:dataset_slug' => 'geography#show_dataset'
  match 'conditions(/:dataset_slug)' => 'home#conditions'

  # static
  get "resources" => 'home#resources'
  get "about" => 'home#about'
  get "partners" => 'home#partners'
  get "partner_sign_up" => 'home#partner_sign_up'

  # json
  match "resources(/:dataset_id)/:north/:east/:south/:west" => 'geography#resources_json'

  # errors
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end

  # root
  root :to => 'home#index'

end
