Rails.application.routes.draw do
  root to: 'top#index'

  get 'top/index', to: 'top#index'
  get 'top/send_email_for_unity', to: 'top#send_email_for_unity'
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
