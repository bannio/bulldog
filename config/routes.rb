Bulldog::Application.routes.draw do

  as :user do
      patch '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
      get '/edit_email' => 'registrations#edit_email', :via => :get, :as => :edit_email_user_registration
  end
  devise_for :users, path: "", controllers: {confirmations: 'confirmations',
                                              sessions: 'sessions',
                                              registrations: 'registrations'}

  # get '/remote_sign_in' => 'remote_content#remote_sign_in', as: :remote_sign_in

  resources :accounts
  resources :bills, except: :show
  resources :customers, except: :show
  resources :invoices
  resources :reports, only: [:new, :create]
  get 'reports' => 'reports#new'
  resources :categories
  resources :vat_rates
  resources :settings, only: [:index, :show, :edit, :update]
  resources :suppliers, only: [:index, :edit, :update]
  resources :welcome, only: [:index]
  resources :plans, only: [:index]

end
