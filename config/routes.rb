Rails.application.routes.draw do
  root to: "pages#home"

  # User for creating, updating and deleting users -> Inside of the registrations_controller
  devise_for :users

  resources :patients, only: [:index, :show]
  resources :treatments, only: [:index, :show]
  resources :vehicles, only: [:index, :show]
  resources :clients, only: [:index, :show]
end
