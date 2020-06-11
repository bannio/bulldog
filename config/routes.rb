Bulldog::Application.routes.draw do

  as :user do
      patch '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
      get '/edit_email' => 'registrations#edit_email', :via => :get, :as => :edit_email_user_registration
  end
  devise_for :users, path: "", controllers: {confirmations: 'confirmations',
                                              sessions: 'sessions',
                                              registrations: 'registrations'}

  # get '/remote_sign_in' => 'remote_content#remote_sign_in', as: :remote_sign_in

  resources :accounts do
    member do
      get 'cancel'
      get 'new_card'
      patch 'update_card'
    end
  end
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
  # post '/send_mail' => 'contacts#send_mail'
  resources :contacts, only: [:new, :create]
  # get "help/:action" => "help#:action"
  get 'help/intro' => 'help#intro'
  get 'help/account' => 'help#account'
  get 'help/bills' => 'help#bills'
  get 'help/categories' => 'help#categories'
  get 'help/customers' => 'help#customers'
  get 'help/invoices' => 'help#invoices'
  get 'help/logo' => 'help#logo'
  get 'help/print_settings' => 'help#print_settings'
  get 'help/reports' => 'help#reports'
  get 'help/setup' => 'help#setup'
  get 'help/subscription' => 'help#subscription'
  get 'help/suppliers' => 'help#suppliers'
  get 'help/vat' => 'help#vat'
  get 'help/video' => 'help#video'

end
