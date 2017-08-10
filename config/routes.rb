Rails.application.routes.draw do
  root 'home#index'

  resources :contractor_requests
  resources :labor_requests
  resources :staff_requests

  resources :users
  get '/logout' => 'users#logout'
  get 'impersonate/user/:user_id' => 'impersonate#create', as: :impersonate_user
  delete 'impersonate/revert' => 'impersonate#destroy', as: :revert_impersonate_user

  resources :organizations
  resources :organization_cutoffs
  resources :review_statuses
end
