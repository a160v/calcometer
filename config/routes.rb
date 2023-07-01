Rails.application.routes.draw do
  devise_for :users

  scope '(:locale)', locale: /it|fr|de/ do
    get 'analytics', to: 'analytics#index'
    resources :patients
    resources :appointments, only: %i[index new create show destroy]
    resources :clients
    root to: "pages#home"
  end
end
