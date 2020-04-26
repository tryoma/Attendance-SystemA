Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :bases do
  end

  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attend_employees'
      get 'attendances/overtime'
      patch 'attendances/request_overtime'
      get 'attendances/reply_overtime'
    end
    collection { post :import }
    resources :attendances, only: :update
   end
  end