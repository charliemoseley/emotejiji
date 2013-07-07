Emotejiji::Application.routes.draw do
  resource :users,    only: [:create, :new]
  resource :sessions, only: [:create, :destroy]

  get '/login',    to: 'users#new'
  get '/register', to: 'users#new'
  get '/logout',   to: 'sessions#destroy'

  # TODO: Figure out a nice way to automagically have the angular routes work
  get '/angular/emoticon_list',  to: 'angular#emoticon_list'
  get '/angular/emoticon',       to: 'angular#emoticon'
  get '/angular/available_tags', to: 'angular#available_tags'
  get '/angular/add_emoticon',   to: 'angular#add_emoticon'

  # Angular Static Controller
  static_routes = ['/emoticons/*id', '/available-tags', '/']
  static_routes.each do |route|
    get route, to: 'static_generator#generate', constraints: { escaped_fragment?: true }
  end

  # TODO: Need to reject routes that have an escaped fragment that are not supposed to be rendered like favorites

  # Angular HTML5 Reroutes
  html5_reroutes = ['/emoticons/*id', '/favorites', '/favorites/*id', '/available-tags', '/add-emoticon']
  html5_reroutes.each do |route|
    get route, to: 'pages#index'
  end
  get  '/emoticons', to: redirect('/')
  root 'pages#index'

  mount API::Router => '/api'
end
