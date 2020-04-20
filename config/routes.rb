Rails.application.routes.draw do

  get 'tracks/create'
  get 'tracks/update'
  get 'playlists/create'
  get "playlists/update"
  root 'users#new'
  get 'create', to: 'users#create'
  resources :users, only: [:show]
  get 'users/finished'
  get 'users/finish_build'
  get 'users/update_build'

end
