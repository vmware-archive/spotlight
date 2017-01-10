Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root to: 'dashboards#index'
  resources :dashboards, only: [:index]
  resources :widgets, only: [:new, :create, :destroy]
  post '/get_auth_token', to: 'auth#get_auth_token'
  namespace :api, defaults: { format: :json } do
    get '/random_comic', to: 'comics#random'
    get '/url/:id', to: 'urls#url'
    get '/url_content_copy/:id', to: 'urls#url_content_copy'

    resources :widgets, only: [:destroy]

    resources :ci_status, only: [:show]

    get '/gcal/:id', to: 'gcal#show'
    get '/gcal/:id/availability', to: 'gcal#availability'

    resources :dashboards, only: [:index, :show, :layout] do
      put '/layout', to: 'dashboards#layout'
      post '/layout', to: 'dashboards#layout'
    end

    resources :google, only: [] do
      collection do
        get '/login', to: 'google#login'
        get '/callback', to: 'google#callback'
      end
    end
  end

  namespace :widget do
    resources :gcal, only: [:new, :create]
    get '/gcal_resource/new', to: 'gcal#new_resource'
    post '/gcal_resource', to: 'gcal#create_resource', as: 'gcal_resource_index'
  end
end
