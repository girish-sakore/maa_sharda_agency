# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  post 'sign_up', to: 'user_block/users#create'
  post 'login', to: 'logins#create'

  namespace :user_block do
    resources :admins
    resources :users
  end

  resources :allocation_drafts do
    collection do
      post :import_allocation
      post :assign_caller
      post :assign_executive
    end
  end

  # No token required
  get 'types', to: 'public_apis#types'
end
