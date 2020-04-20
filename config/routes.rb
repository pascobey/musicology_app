Rails.application.routes.draw do

  get 'tracks/create'
  get 'tracks/update'
  get 'playlists/create'
  get "playlists/update"
  root 'users#new'
  get 'create', to: 'users#create'
  resources :users, only: [:show, :finished, :finish_build, :update_build]

end
