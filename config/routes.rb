Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  scope ':locale', locale: /#{I18n.available_locales.join('|')}/ do
    devise_for :users, skip: :omniauth_callbacks, controllers: {
      registrations: 'users/registrations'
    }

    get 'analytics', to: 'analytics#index'
    post 'update_locale', to: 'application#update_locale'
    resources :patients
    resources :appointments, only: %i[index new create show destroy] do
      collection do
        post :calculate_daily_driving_distance_and_duration_from_service
      end
    end
    resources :clients
    # Homepage
    root to: 'pages#home'
  end

  # Catch all requests without an available locale and redirect to the default locale.
  # The constraint is made to not redirect a 404 of an existing locale on itself
  get '*path', to: redirect("/#{I18n.default_locale}/%{path}"),
               constraints: { path: %r{(?!(#{I18n.available_locales.join('|')})\/).*} }
end
