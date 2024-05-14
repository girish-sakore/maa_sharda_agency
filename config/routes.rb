# frozen_string_literal: true

Rails.application.routes.draw do

  # Defines the root path route ("/")
  # root "articles#index"  resources :users

  resources :admins
  resources :allocation_drafts

  post "import_allocation", to: "allocation_drafts#import"
  post 'login', to: 'logins#create'
end
