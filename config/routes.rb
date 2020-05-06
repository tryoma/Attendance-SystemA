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
      get 'reference' #勤怠確認ページ
      get 'edit_basic_info' #ユーザー情報編集ページ
      patch 'update_basic_info'
      get 'attendances/edit_one_month' #勤怠編集ページ
      patch 'attendances/request_edit_one_month'
      get 'attendances/reply_edit_one_month' #勤怠編集確認ページ(上長)
      patch 'attendances/update_one_month'
      get 'attend_employees'
      get 'attendances/overtime' #残業申請ページ
      patch 'attendances/request_overtime'
      get 'attendances/reply_overtime' #残業申請確認ページ(上長)
      patch 'attendances/to_reply_overtime'
    end
    collection { post :import }
    resources :attendances, only: :update
   end
  end