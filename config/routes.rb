Emotejiji::Application.routes.draw do
  resource :users,    only: [:create, :new]
  resource :sessions, only: [:new, :create, :destroy]

  get '/signup',  to: 'users#new'
  get '/signin',  to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'

  # TODO: Figure out a nice way to automagically have the angular routes work
  get '/angular/emoticon_list',  to: 'angular#emoticon_list'
  get '/angular/emoticon',       to: 'angular#emoticon'
  get '/angular/available_tags', to: 'angular#available_tags'
  get '/angular/add_emoticon',   to: 'angular#add_emoticon'

  # Angular HTML5 Reroutes
  get '/emoticons',        to: redirect('/')
  get '/emoticons/*other', to: 'pages#index'
  get '/favorites',        to: 'pages#index'
  get '/favorites/*other', to: 'pages#index'
  get '/available-tags',   to: 'pages#index'
  get '/add-emoticon',     to: 'pages#index'

  root "pages#index"

  mount API::Router => '/'
end
