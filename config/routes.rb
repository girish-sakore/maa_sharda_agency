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
  
  resources :financial_entities
  resources :allocation_drafts do
    collection do
      post :import_allocation
      post :assign_caller
      post :assign_executive
      post :update_feedback
    end
  end
  
  resources :dashboards do
    collection do
      get :get_allocations
    end
  end
  
  resources :feedback_codes
  resources :feedback_sub_codes
  resources :feedbacks

  # No token required
  get 'types', to: 'public_apis#types'
end
