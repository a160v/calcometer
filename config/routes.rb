Rails.application.routes.draw do
  # get "pages#home"
  root to: "treatments#index"

  # User for creating, updating and deleting users -> Inside of the registrations_controller
  devise_for :users
  resources :patients
  resources :treatments do
    member do
      get 'address'
      get 'previous_address'
    end
  end
  resources :clients
end
