Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get 'analytics', to: 'analytics#index'
  resources :patients
  resources :appointments, only: %i[index new create show destroy]
  resources :clients
end
