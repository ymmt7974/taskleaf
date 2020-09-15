Rails.application.routes.draw do

  root to: 'tasks#index'
  # login/logout
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # タスク
  resources :tasks
  
  # ユーザー（管理者）
  namespace :admin do
    resources :users
  end
end
