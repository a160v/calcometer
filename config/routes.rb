Rails.application.routes.draw do
  # get "pages#home"
  root to: "pages#home"

  # User for creating, updating and deleting users -> Inside of the registrations_controller
  devise_for :users
  resources :patients do
    member do
      get 'address'
      get 'next_patient_address'
    end
  end
  resources :treatments
  resources :clients
end
