Rails.application.routes.draw do
  get 'analytics', to: 'analytics#index'

  # User for creating, updating and deleting users -> Inside of the registrations_controller
  devise_for :users
  resources :patients
  resources :appointments do
    member do
      get 'address'
      get 'previous_address'
    end
  end
  resources :clients

  # get "pages#home"
  root to: "pages#home"
end
