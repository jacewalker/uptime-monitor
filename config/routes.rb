Rails.application.routes.draw do
  resources :uptimes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'uptimes#dashboard'
  get '/settings', to: 'uptimes#settings'
  get '/monitor', to: 'uptimes#monitor'
  # Defines the root path route ("/")
  # root "articles#index"
end
