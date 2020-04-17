Rails.application.routes.draw do

  root 'users#new'
  get 'create', to: 'users#create'
  get 'building', to: 'users#build'
  resources :users, only: [:show]

end
