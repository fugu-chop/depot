Rails.application.routes.draw do
  get 'admin/index'
  get 'session_store/new'
  get 'session_store/create'
  get 'session_store/destroy'
  resources :users
  resources :orders
  resources :line_items
  resources :carts
  root "store#index", as: 'store_index'
  resources :products do
    get :who_bought, on: :member
  end

  # Required so we can set the session 
  # in the carts controller show test
  if Rails.env.test?
    namespace :test do
      resource :session, only: %i[create]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
