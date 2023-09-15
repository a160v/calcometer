Rails.application.routes.draw do
  # Routes for devise and omniauth (Google)
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  # Routes are scoped by the locales available in the application
  scope ':locale', locale: /#{I18n.available_locales.join('|')}/ do
    resources :patients, only: %i[index new create show destroy]
    resources :appointments, only: %i[index daily_index new create show destroy], shallow: true do
      collection do
        get :daily_index
        post :calculate_distance_and_duration
      end
    end

    devise_for :users, skip: :omniauth_callbacks, controllers: {
      registrations: 'users/registrations'
    }

    # General application-level route
    post 'update_locale', to: 'application#update_locale'
  end

  # Homepage
  root to: 'pages#home'

  # Catch all requests without an available locale and redirect to the default locale.
  # The constraint is made to not redirect a 404 of an existing locale on itself
  get '*path', to: redirect("/#{I18n.default_locale}/%{path}"),
               constraints: { path: %r{(?!(#{I18n.available_locales.join('|')})\/).*} }
end
