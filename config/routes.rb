Emotejiji::Application.routes.draw do
  resource :users,    only: [:create, :new]
  resource :sessions, only: [:new, :create, :destroy]

  get '/signup',  to: 'users#new'
  get '/signin',  to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'

  # TODO: Figure out a nice way to automagically have the angular routes work
  get '/angular/emoticon_list', to: 'angular#emoticon_list'
  get '/angular/emoticon',      to: 'angular#emoticon'

  root "pages#index"
  mount Emotejiji::API::Router => '/'
end
