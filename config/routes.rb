Rails.application.routes.draw do
  resources :net_worth_snapshots
  resources :transactions
  resources :account_snapshots
  resources :accounts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
