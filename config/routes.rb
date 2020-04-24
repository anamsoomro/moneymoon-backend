Rails.application.routes.draw do
  resources :plaid_accounts
  resources :plaid_items
  resources :users
  resources :accounts
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post "/get_access_token", to: "plaid#getAccessToken"
  # https://www.keycdn.com/support/422-unprocessable-entity

  get "/accounts/:id/get_data", to: "plaid#getData"

  get "/transactions", to: "plaid#getTransactions"

  post "/login", to: "auth#create"
  # sign up is post "/users"

end
