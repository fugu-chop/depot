Rails.application.routes.draw do
  get 'admin' => 'admin#index' 
  controller :session_store do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  
  resources :support_requests, only: [:index, :update]
  resources :users
  resources :products do
    get :who_bought, on: :member
  end

  scope '(:locale)' do 
    resources :orders
    resources :line_items
    resources :carts
    root "store#index", as: 'store_index', via: :all
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
