Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  authenticated :user do
    root to: 'homes#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'groups/selectcreateorjoin#select'
  end

  namespace :groups do
    get  'selectcreateorjoin/select'
    post 'selectcreateorjoin/decide'
    get  'selectcreateorjoin/form'
    post 'selectcreateorjoin/save_form'
  end

  get 'chores/new'
  get 'chores/create'
  get 'homes/index'


  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :chores, only: [:new, :create]
end