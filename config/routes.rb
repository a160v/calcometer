Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  # Routes are scoped by the locales available in the application
  scope ':locale', locale: /#{I18n.available_locales.join('|')}/ do
    # Routes for devise and omniauth (Google)
    devise_for :users, skip: :omniauth_callbacks, controllers: {
      registrations: 'users/registrations'
    }

    # All appointments view
    get 'analytics', to: 'analytics#index'
    # Route for user to select locale
    post 'update_locale', to: 'application#update_locale'

    # Invite other members to join tenant
    resources :tenants do
      resources :members do
        collection do
          post :invite
        end
      end
    end
    
    resources :patients
    resources :appointments, only: %i[index new create show destroy] do
      collection do
        post :calculate_daily_driving_distance_and_duration_from_service
      end
    end
    # Homepage
    root to: 'pages#home'
  end

  # Catch all requests without an available locale and redirect to the default locale.
  # The constraint is made to not redirect a 404 of an existing locale on itself
  get '*path', to: redirect("/#{I18n.default_locale}/%{path}"),
               constraints: { path: %r{(?!(#{I18n.available_locales.join('|')})\/).*} }
end
