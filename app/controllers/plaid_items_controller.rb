class PlaidItemsController < ApplicationController

  skip_before_action :logged_in?, only: [:index] # because I want to see them

  def index 
    pi = PlaidItem.all 
    render json: pi
  end
  
  def show 
    # show all plaid items related to one account
    account = Account.find(params[:account_id])
    account.plaid_items
    # plaid items have access token, user_id, p_item_id, p_institution
    # do accounts have a p_item_id they do not. i can either inject an item_id into all accounts. 
    # or i can go through get all their accounts here
  end

  def destroy 
    item = PlaidItem.find(params[:account_id])
    item.destroy
    render json: {}
  end
  
end
