Rails.application.routes.draw do

  get 'profile/index'
  get 'profile/edit'
  get 'profile/update'
  
  get  'selectcreateorjoin/select'
  post 'selectcreateorjoin/decide'
  get  'selectcreateorjoin/form'
  get 'selectcreateorjoin/save_form', to: 'selectcreateorjoin#form'
  post 'selectcreateorjoin/save_form'

  get 'homes/index'
  get 'homes/previous'

  resources :categories, only: [:index, :new,:create, :destroy]

  resources :chores do
    collection do
      get :history
    end
  end

  resources :achievements, only: [:index]

  resources :rewards, only: [:index, :new, :create, :edit, :update] do
    post :expend, on: :member
  end

  resources :chore_dates, only: [:destroy, :show] do
    member do
      post :complete
    end
    collection do
      patch :reschedule
    end
  end

  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: "sessions" ,
  }

  authenticated :user do
    root to: 'homes#index', as: :authenticated_root
  end

  unauthenticated do
    root to: redirect('/users/sign_in')
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :chores, only: [:new, :create]

  resource :push_subscription, only: [:create, :destroy]

  post "test_push", to: "push_tests#create"
end