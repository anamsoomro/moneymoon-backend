class PlaidItemsController < ApplicationController

  skip_before_action :logged_in?, only: [:index] 

  def index 
    pi = PlaidItem.all 
    render json: pi
  end
  
  def show 
    account = Account.find(params[:account_id])
    account.plaid_items
  end

  def destroy 
    item = PlaidItem.find(params[:account_id])
    item.destroy
    render json: {}
  end
  
end
