Rails.application.routes.draw do
  root to: 'top#index'

  get 'top/index', to: 'top#index'
  get 'top/fetch_gmail', to: 'top#fetch_gmail'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
