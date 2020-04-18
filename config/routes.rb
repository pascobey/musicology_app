Rails.application.routes.draw do

  root 'users#new'
  get 'create', to: 'users#create'
  resources :users, only: [:show]
  resources :tracks, only: [:show, :create]
  resources :playlists, only: [:show, :create]

end
