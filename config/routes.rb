Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "users#show"
  resources :users

  get '/debts', to: 'users#debts'
  get '/loans', to: 'users#loans'

  get '/transaction/new', to: 'ious#new'
  post '/transaction/new', to: 'ious#create'

  get '/reminder', to: 'users#send_reminder_mail', as: :send_reminder_mail
  get '/paid', to: 'users#send_paid_mail', as: :send_paid_mail

end
