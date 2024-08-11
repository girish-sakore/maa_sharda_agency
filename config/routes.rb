# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Defines the root path route ("/")
  # root "articles#index"  resources :users

  namespace :user_block do
    resources :admins
    resources :users
  end
  post 'sign_up', to: 'user_block/users#create'

  resources :allocation_drafts

  post "import_allocation", to: "allocation_drafts#import"
  post 'login', to: 'logins#create'

  # Public apis without auth token
  get 'types', to: 'public_apis#types'
end
