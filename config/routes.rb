Emotejiji::Application.routes.draw do
  resource :users,    only: [:create, :new]
  resource :sessions, only: [:new, :create, :destroy]

  get '/signup',  to: 'users#new'
  get '/signin',  to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'

  # TODO: Figure out a nice way to automagically have the angular routes work
  get '/angular/emoticon_list', to: 'angular#emoticon_list'
  get '/angular/emoticon',      to: 'angular#emoticon'


  # Angular HTML5 Reroutes
  get '/emoticons',        to: redirect('/')
  get '/emoticons/*other', to: 'pages#index'
  get '/favorites',        to: 'pages#index'
  get '/favorites/*other', to: 'pages#index'
  root "pages#index"
  mount Emotejiji::API::Router => '/'
end
