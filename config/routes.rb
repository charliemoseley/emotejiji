Emotejiji::Application.routes.draw do
  resource :users,    only: [:create, :new]
  resource :sessions, only: [:new, :create, :destroy]

  get '/signup',  to: 'users#new'
  get '/signin',  to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'
  
  root "pages#index"
  mount Emotejiji::API::Router => '/'
end
