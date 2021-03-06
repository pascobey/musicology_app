Rails.application.routes.draw do

  get 'status/build'
  get 'tracks/create'
  get 'tracks/update'
  get 'playlists/create'
  get "playlists/update"
  root 'users#new'
  get 'create', to: 'users#create'
  resources :users, only: [:show]
  get 'end', to: 'users#end'
  get 'about', to: 'about#index'

end
