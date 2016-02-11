Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root to: 'dashboards#index'
  resources :dashboards, only: [:index]
  resources :widgets, only: [:new, :create, :destroy]
  namespace :api, defaults: { format: :json } do
    resources :ci_status, only: [:show]
    resources :gcal, only: [:show]
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
  end
end
