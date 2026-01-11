Rails.application.routes.draw do

  get 'profile/index'
  get 'profile/edit'
  get 'profile/update'
  
  get  'selectcreateorjoin/select'
  post 'selectcreateorjoin/decide'
  get  'selectcreateorjoin/form'
  post 'selectcreateorjoin/save_form'

  get 'homes/index'
  
  resources :chores

  def after_sign_out_path_for(resource_or_scope)
    selectcreateorjoin_select_path
  end

  devise_for :users, controllers: {
    registrations: 'registrations',
    confirmations: "confirmations"
  }

  authenticated :user do
    root to: 'homes#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'selectcreateorjoin#select'
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :chores, only: [:new, :create]
end