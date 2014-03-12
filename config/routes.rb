Bulldog::Application.routes.draw do

  as :user do
      patch '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  end
  devise_for :users, path: "", controllers: {confirmations: 'confirmations'}

  resources :accounts
  resources :bills, except: :show
  resources :customers, except: :show
  resources :invoices
  resources :reports, only: [:new, :create]
  get 'reports' => 'reports#new'
  resources :categories

end
