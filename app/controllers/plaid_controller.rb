require 'date'

class PlaidController < ApplicationController

  skip_before_action :verify_authenticity_token # https://stackoverflow.com/questions/27098239/post-422-unprocessable-entity-in-rails-due-to-the-routes-or-the-controller
  skip_before_action :logged_in?, only: [:assets] # testing



@@client = Plaid::Client.new(env: :sandbox,
                              client_id: ENV["CLIENT_ID"],
                              secret: ENV["SECRET"],
                              public_key: ENV["PUBLIC_KEY"])

  # on user adding new institution 
  def getAccessToken 
    exchange_token_response = @@client.item.public_token.exchange(params['public_token']) # get access
    access_token = exchange_token_response['access_token']
    item_id = exchange_token_response['item_id']
    # create plaid item (institution)
    user = User.find(params['user_id'])
    pi = PlaidItem.create({
      p_access_token: access_token,
      user_id: user.id,
      p_item_id: item_id, 
      p_institution: params['institution'] 
    })
    transactions = getTransactions(pi, user)
    accounts = getBalances(pi, user)
    render json: {transactions: transactions, accounts: accounts}
  end                       

  def getData # account will have many institutions. make fetch for each institution and consolidate 
    accounts = []
    transactions = []
    account = Account.find(params['id']) # get their account
    plaidItems = account.plaid_items # get all items related to their account
    plaidItems.each do |item| # get data for each and rack em up
      user = item.user # owner of plaid item
      transactions << getTransactions(item, user)
      accounts << getBalances(item, user)
    end
    # if no plaid items {trans: [], accounts: []}, each item is an array. 
    render json: {transactions: transactions.flatten, accounts: accounts.flatten}
  end


  def getTransactions(item, user)
    now = Date.today
    thirty_days_ago = (now - 30)
    begin
      product_response = @@client.transactions.get(item.p_access_token, thirty_days_ago, now)
      transactions = product_response.transactions.map do |transaction|  # map user into each transaction object 
        transaction[:user] = {username: user.username, id: user.id} # add a user key and set it to the owner
        transaction[:institution] = item.p_institution # add institution name
        transaction[:item_id] = item.p_item_id
        transaction
      end
    rescue Plaid::PlaidAPIError => e
      error_response = format_error(e)
      transactions =  error_response
    end
    return transactions # [ {trans}, {trans}, {trans}]
  end



  def getBalances(item, user)
    begin
      product_response = @@client.accounts.balance.get(item.p_access_token)
      balances = product_response.accounts.map do |account| 
        account[:user] = {username: user.username, id: user.id}
        account[:institution] = item.p_institution
        account[:item_id] = item.p_item_id
        account
      end
    rescue Plaid::PlaidAPIError => e
      error_response = format_error(e)
      balances = error_response
    end
    return balances # [ {acc}, {acc}, {acc}] 
  end


  def transactionsForMonth
    transactions = []
    year = 2020
    month = params[:month].to_i
    month_start = Date.new(year, month, 1)  #=> #<Date: 2017-05-01 ...>
    month_end = Date.new(year, month, -1) 
    account = Account.find(params['account_id'])
    plaidItems = account.plaid_items
    plaidItems.each do |item|
      user = item.user 
      begin
        product_response = @@client.transactions.get(item.p_access_token, month_start, month_end)
        productTransactions = product_response.transactions.map do |transaction| 
          transaction[:user] = {username: user.username, id: user.id} # add a user key and set it to the owner
          transaction[:institution] = item.p_institution # add institution name
          transaction[:item_id] = item.p_item_id
          transaction
        end
      rescue Plaid::PlaidAPIError => error_response
        error_response = format_error(e)
        productTransactions =  error_response
      end
      transactions << productTransactions
    end
    render json: transactions.flatten
  end

  def deleteItem 
    item = PlaidItem.find_by(p_item_id: params[:id])
    item_id = item.p_item_id
    @@client.item.remove(item.p_access_token)
    item.destroy()
    render json: {item_id: item_id}
  end


  def format_error(err)
    { error: {
      error_code: err.error_code,
      error_message: err.error_message,
      error_type: err.error_type
     }
    }
  end

  def strong_params
    params.permit(:institution)
  end


end