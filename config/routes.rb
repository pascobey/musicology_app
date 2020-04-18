Rails.application.routes.draw do

  get 'tracks/create'
  get 'tracks/show'
  get 'playlists/create'
  get 'playlists/show'
  root 'users#new'
  get 'create', to: 'users#create'
  get 'building', to: 'users#build'
  resources :users, only: [:show]

end
