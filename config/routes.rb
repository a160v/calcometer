Rails.application.routes.draw do
  devise_for :users

  scope ':locale', locale: /#{I18n.available_locales.join('|')}/ do
    get 'analytics', to: 'analytics#index'
    resources :patients
    resources :appointments, only: %i[index new create show destroy]
    resources :clients
    # Homepage
    root to: 'pages#home'
  end

  # Catch all requests without a available locale and redirect to the default locale.
  # The constraint is made to not redirect a 404 of an existing locale on itself
  get '*path', to: redirect("/#{I18n.default_locale}/%{path}"),
               constraints: { path: %r{(?!(#{I18n.available_locales.join('|')})\/).*} }
end
