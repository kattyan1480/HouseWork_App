Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'groups/selectcreateorjoin#select'
  namespace :groups do
    get  'selectcreateorjoin/select'
    post 'selectcreateorjoin/decide'
    get  'selectcreateorjoin/form'
    post 'selectcreateorjoin/save_form'
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
end