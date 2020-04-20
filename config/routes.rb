Rails.application.routes.draw do

  get 'status/finished'
  get 'status/finish_build'
  get 'status/update_build'
  get 'tracks/create'
  get 'tracks/update'
  get 'playlists/create'
  get "playlists/update"
  root 'users#new'
  get 'create', to: 'users#create'
  resources :users, only: [:show]

end
