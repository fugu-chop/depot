Rails.application.routes.draw do
  resources :orders
  resources :line_items
  resources :carts
  root "store#index", as: 'store_index'
  resources :products

  # Required so we can set the session 
  # in the carts controller show test
  if Rails.env.test?
    namespace :test do
      resource :session, only: %i[create]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
