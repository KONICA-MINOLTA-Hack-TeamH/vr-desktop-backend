Rails.application.routes.draw do
  root to: 'top#index'

  get 'top/index', to: 'top#index'
#  get 'top/fetch_gmail', to: 'top#fetch_gmail'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'top/send_email_for_unity', to: 'top#send_email_for_unity'
  get 'top/send_mail_for_unity', to: 'top#send_mail_for_unity'
  get 'top/new_mail_arrive', to: 'top#new_mail_arrive'
  get 'top/get_next_send_mail', to: 'top#get_next_send_mail'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
