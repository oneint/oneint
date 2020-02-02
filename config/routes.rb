Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root 'workspaces#show', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  resources :workspaces
  resources :integrations, except: [:destroy] do
    collection do
      get :add
    end
  end
  resources :requests, only: [:new, :create, :show]
  resources :webhooks, only: [] do
    collection do
      post :appsflyer
    end
  end

  resources :accounts, only: [] do
    get :profile, on: :collection
    patch :update, on: :collection
  end

  namespace :api do
    resources :requests, only: [:create, :index, :show]
  end
  mount Sidekiq::Web => '/sidekiq'

end
