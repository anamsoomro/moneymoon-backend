class AccountsController < ApplicationController
  
  def index 
    accounts = Accounts.all 
    render json: accounts
  end
  
end
