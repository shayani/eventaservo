# frozen_string_literal: true

Rails.application.routes.draw do
  # Dynamic error pages
  get '/robots.txt', to: 'home#robots'
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'
  get '/privateco', to: 'home#privateco'
  get '/license', to: 'home#privateco'
  get '/v/:view_style', to: 'home#view_style', as: 'view_style'
  get '/prie', to: 'home#prie'
  get '/changelog', to: 'home#changelog'
  get '/rss.xml', to: 'home#feed', as: 'events_rss'
  get '/events.json', to: 'home#events'
  get '/search', to: 'home#search'
  get '/statistikoj', to: 'home#statistics'
  get '/akcepti_kuketojn', to: 'home#accept_cookies'
  get '/forigas_kuketojn', to: 'home#reset_cookies'

  root to: 'home#index'

  devise_for :users, controllers: { sessions:           'users/sessions',
                                    registrations:      'users/registrations',
                                    omniauth_callbacks: 'users/omniauth_callbacks' }

  # Mallongigoj kaj alidirektoj
  get '/r', to: redirect('/users/sign_up')
  get '/eventoj/:code', to: redirect('/e/%{code}')
  get '/vidmaniero/:view_style', to: redirect('/v/%{view_style}')
  get '/e/nova', to: redirect('/e/new')

  # API
  namespace :api do
    namespace :v1 do
      get 'events', to: 'events#index'
      get 'uzanto/:id/rekrei_api_kodon', to: 'users#rekrei_api_kodon', as: 'rekrei_api_kodon'
    end
    namespace :v2 do
      get 'eventoj/e/:ligilo', to: 'eventoj#evento'
      get 'eventoj', to: 'eventoj#index'
    end
  end

  # iloj
  namespace :iloj do
    get 'mallongilo_disponeblas', to: 'mallongilo#disponeblas'
    post 'elektas_horzonon', to: 'horzono#elektas'
    get 'forvishas_horzonon', to: 'horzono#forvishas'
  end

  # Webcal
  namespace :webcal do
    get 'lando/:landa_kodo', to: 'webcal#lando'
    get 'o/:short_name', to: 'webcal#organizo', as: 'organizo'
  end

  # Internacia kalendaro
  get 'j/:jaro', to: 'internacia#jaro', as: 'internacia_kalendaro'
  get '/jaro/:jaro', to: redirect('/j/%{jaro}')
  get '/eventoj-hu', to: redirect('/j/2020?eventoj=hu')

  # Anoncoj kaj Konkursoj
  get '/anoncoj', to: 'home#anoncoj', as: 'anoncoj'

  # Organizoj
  defaults format: :json do
    get '/o/cheforganizoj.json', to: 'organizations#cheforganizoj'
  end
  get '/o/search', to: 'organizations#search', as: 'organization_search'
  resources :organizations, path: 'o', param: 'short_name' do
    post 'aldoni_uzanton', to: 'organizations#aldoni_uzanton'
    get 'estrighu/:username', to: 'organizations#estrighu', as: 'estrighu'
    get 'forighu/:username', to: 'organizations#forighu', as: 'forighu'
  end

  # Eventoj
  get '/importi', to: 'events#nova_importado', as: 'importi_eventon'
  post '/importi', to: 'events#importi'
  resources :events, path: 'e', param: 'code' do
    get 'follow', to: 'followers#event', as: 'toggle_follow'
    delete 'delete_file/:file_id', to: 'events#delete_file', as: 'delete_file'
    post 'kontakti_organizanton', to: 'events#kontakti_organizanton', as: 'kontakti_organizanton'
    post 'nuligi', to: 'events#nuligi', as: 'nuligi'
    get 'malnuligi', to: 'events#malnuligi', as: 'malnuligi'
    get 'kronologio', to: 'events#kronologio'
  end

  # Admin
  namespace :admin do
    resources :users, only: %i[index show]
    get 'sciiga_listo', controller: 'notifications', action: :index, as: 'notification_list'
    get 'countries', controller: 'countries', action: :index
    get 'eventoj', controller: 'events', action: :index
    get 'forigitaj_eventoj', controller: 'events', action: :deleted
    get 'senlokaj_eventoj', to: 'events#senlokaj_eventoj'
    patch 'forigitaj_eventoj/restauri/:event_code', controller: 'events', action: :recover, as: 'recover_event'
    get 'analizado', to: 'analizado#index'
    get 'analizado_lau_retumiloj', to: 'analizado#lau_retumiloj'
    get 'analizado_lau_sistemoj', to: 'analizado#lau_sistemoj'
    get 'analizado_lau_vidmaniero', to: 'analizado#lau_vidmaniero'
    get 'analizado_lau_tago', to: 'analizado#lau_tago'
  end

  # Aldonaĵoj
  match 'upload/:record_id' => 'attachments#upload', as: 'attachment_upload', via: :post
  match 'dosiero/:id/forighu' => 'attachments#destroy', as: 'attachment_destroy', via: :delete

  # Eventoj de uzantoj
  get '/uzanto/:username', controller: 'events', action: 'by_username', as: 'events_by_username'

  # Sciigo
  get '/sciigo/:recipient_code/forigu', controller: 'notification_list', action: :delete, as: 'delete_recipient'
  post '/sciigo', controller: 'notification_list', action: :create, as: 'new_recipient'

  # Landoj kaj urboj
  get '/:continent', to: 'events#by_continent', as: 'events_by_continent'
  get '/:continent/:country_name', controller: 'events', action: 'by_country', as: 'events_by_country'
  # get '/lando/:country_name', controller: 'events', action: 'by_country', as: 'events_by_country'
  get '/:continent/:country_name/:city_name', controller: 'events', action: 'by_city', as: 'events_by_city'
  # get '/lando/:country_name/:city_name', controller: 'events', action: 'by_city', as: 'events_by_city'

end
