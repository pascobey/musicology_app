Rails.application.routes.draw do

  get 'tracks/create'
  get 'playlists/create'
  root 'users#new'
  get 'create', to: 'users#create'
  resources :users, only: [:show, :finish_build, :update_build]

end
