Rails.application.routes.draw do

  namespace :admin do
    root 'main#index'
    get 'login' => 'main#login'
    post 'login_post' => 'main#login_post'
    get 'logout' => 'main#logout'
    post 'modify_passwd' => 'main#modify_passwd'

    resources :uploads do
      post 'image', on: :collection
      post 'file', on: :collection
    end

    resources :dashboard, only: [:index] do
      get 'export', on: :collection
    end

    resources :admins do
      get 'passwd', on: :member
      put 'passwd_post', on: :member
    end

    resources :users
    resources :import_companies
    resources :bulk_wine_vendors

    resources :bulk_wines do
      patch 'status', on: :member
      get 'get_json', on: :collection
    end
    resources :bulk_wine_stocks do
      get 'stock', on: :member
      post 'stock_add', on: :member
      get 'get_json', on: :collection
      get 'export', on: :collection
    end

    resources :bulk_wine_tables do
      get 'data', on: :collection
    end

    resources :bulk_wine_years
    resources :bulk_wine_areas
    resources :bulk_wine_varieties
    resources :bulk_wine_sorts

    resources :caps
    resources :corks
    resources :bottles do
      patch 'status', on: :member
      post 'service_fee_upload', on: :collection
      get 'select_options', on: :collection
      get 'service_prices', on: :member
      get 'export', on: :collection
    end

    resources :dividers
    resources :cartons
    resources :cap_colors

    # get '/wine_label/:wine_label_id/fill' => 'wine_labels#fill'
    # put '/wine_label/:wine_label_id' => 'wine_labels#fill_wine_label'
    # post 'create/wine_label/ajax' => 'wine_labels#ajax_create_wine_label'
    # resources :wine_labels

    resources :productions, only: [:show]
    resources :order_productions, only: [:new, :destroy] do
      get 'modal', on: :member
      put 'ajax_update', on: :member
      post 'produce_type', on: :member
      get 'change_bottle_type', on: :member
    end

    resources :quotations, only: [:index] do
      get 'export', on: :collection
    end

    resources :orders_new, only: [:index]

    resources :orders do
      patch 'cancel', on: :member
      patch 'restore', on: :member
      patch 'submit', on: :member
      get 'confirm', on: :member
      get 'recheck', on: :member
      patch 'produced', on: :member
      patch 'pay', on: :member
      patch 'renew', on: :member
      get 'export', on: :collection
      get 'print', on: :member
      patch 'cancel_submit', on: :member
      patch 'cancel_recheck', on: :member
      # patch 'cancel_produce', on: :member
    end

    resources :order_tables do
      get 'data', on: :collection
    end

    resources :deliveries do
      get 'transition', on: :collection
      get 'send', on: :member
      put 'send_put', on: :member
      patch 'status', on: :member
      patch 'cancel', on: :member
      get 'export', on: :collection
      get 'manager', on: :member
      get 'container/new' => :container_new, on: :member
      put 'container/:container_id/selected' => :container_selected, on: :member
      patch 'no_need', on: :member
    end
    resources :containers, only: [:destroy]

    resources :web_product_categories
    resources :web_products
  end

  # namespace :company do
  scope module: :company do
    get '/' => 'main#index'
    get '/cn' => 'main#index_cn'
    get '/products/:cate' => 'main#products'
  end
end
