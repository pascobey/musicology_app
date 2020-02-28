Rails.application.routes.draw do

  root 'users#new'
  get 'create', to: 'users#create'
  get 'users/show'

end
