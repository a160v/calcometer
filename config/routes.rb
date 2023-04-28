Rails.application.routes.draw do
  # get "pages#home"
  root to: "pages#home"

  # User for creating, updating and deleting users -> Inside of the registrations_controller
  devise_for :users

  resources :patients
  resources :treatments
  resources :clients
end
