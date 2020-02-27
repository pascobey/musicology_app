Rails.application.routes.draw do

  # get 'login', to: 'users#new'
  root 'users#new'
  get 'thanks', to: 'users#show'
  # get 'users/new'
  # get 'users/create'
  # get 'users/edit'
  # get 'users/update'
  # get 'users/delete'
  # get 'users/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
