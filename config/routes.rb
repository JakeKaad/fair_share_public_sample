Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, controllers: { registrations: 'users' }

  root 'static_pages#home'

  scope controller: :static_pages do
    get :help
  end

  # root "home#landing"
  # get "/home", to: "home#index"

  resources :families do
    member { post "/archive", to: "families#archive" }
    collection { post  "/search", to: "families#search" }
    resources :students, only: [:create]
    resources :members, only: [:create]
    resources :hours
  end

  post "/members/add_activity", to: "members#add_activity"
  post "/members/remove_activity", to: "members#remove_activity"

  resources :categories, only: [:index, :create, :show, :edit, :update] do
    member { post "/archive", to: "categories#archive" }
  end

  resources :activities, only: [:index, :create, :show, :edit, :update] do
    member { post "/archive", to: "activities#archive" }
  end

  resources :subactivities, only: [:index, :create, :edit, :update] do
    member { post "/archive", to: "subactivities#archive" }
  end

  resources :hours, only: [:index, :create, :edit, :update, :destroy] do
    collection do
      get 'get_subactivities', to: "hours#get_subactivities"
      get 'get_quantity', to: "hours#get_quantity"
    end
  end

  resources :members, only: [:index, :show, :edit, :update] do
    member do
      post "/archive", to: "members#archive"
      post "add_all_activities", to: "members#add_all_activities"
      post "remove_all_activities", to: "members#remove_all_activities"
      get  "/invite", to: "members#invite"
    end

    collection { post  "/search", to: "members#search" }
  end

  resources :students, only: [:index, :edit, :update] do
    member { post "/archive", to: "students#archive" }
    collection { post  "/search", to: "students#search" }
  end

  resources :admin, only: [:show]
  resources :users, only: [:update]
  get "/send_registration_emails", to: "admin#send_registration_emails"
  get "register/:registration_token", to: "users#new_with_registration_token", as: "register_with_token"

  require 'sidekiq/web'

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end
end
