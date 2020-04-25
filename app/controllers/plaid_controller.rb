require 'date'

class PlaidController < ApplicationController

  skip_before_action :verify_authenticity_token # https://stackoverflow.com/questions/27098239/post-422-unprocessable-entity-in-rails-due-to-the-routes-or-the-controller

  # i think im suppose to put this somewhere else 
  @@client = Plaid::Client.new(env: :sandbox,
                             client_id: "5e9b96c18a49a900129cd1f3",
                             secret: "513e54a8369a1359eea03efcdca830",
                             public_key: "38e9fa8478f20a384db53c1176e9b7")

  @@access_token = nil

  @@item_id = nil

  # on user adding new institution 
  def getAccessToken 
    exchange_token_response = @@client.item.public_token.exchange(params['public_token']) # get access
    #  everytime you link it, it gives a new access token a new item_id?? 
    # "{"access_token":"access-sandbox-35cda5a6-fa6e-4aab-96ae-7c7d2e182533","item_id":"X49RJrkwmEhkMxD8brZyhznPWzgdL8fdKpxBX","request_id":"RfhSal2vZKKEkc7"}"
    access_token = exchange_token_response['access_token']
    item_id = exchange_token_response['item_id']

    # create plaid item (institution)
    user = User.find(params['user_id'])
    pi = PlaidItem.create({
      p_access_token: access_token,
      user_id: user.id,
      p_item_id: item_id
    })

    # get last 30 days of transactions from all accounts in item
    now = Date.today
    thirty_days_ago = (now - 30)
    begin
      product_response = @@client.transactions.get(access_token, thirty_days_ago, now)
      transactions = product_response.transactions.map do |transaction|
        transaction[:user] = {username: user.username, id: user.id}
        transaction
      end
    rescue Plaid::PlaidAPIError => e
      error_response = format_error(e)
      transactions = error_response
    end

    #get balances for each account of an item
    begin
      product_response = @@client.accounts.balance.get(access_token)
      accounts = product_response.accounts.map do |account|
        account[:user] = {username: user.username, id: user.id}
        account
      end
    rescue Plaid::PlaidAPIError => e
      error_response = format_error(e)
      accounts = error_response
    end

    render json: {transactions: transactions, accounts: accounts}
  end                       


  # on dash page load
  def getData # account will have many institutions. make fetch for each institution and consolidate 
    transactions = []
    accounts = []
    account = Account.find(params['id']) # get their account
    plaidItems = account.plaid_items # get all items related to their account
    plaidItems.each do |item| # get data for each and rack em up
      user = item.user # owner of plaid item
      transactions << getTransactions(item.p_access_token, user)
      accounts << getBalances(item.p_access_token, user)
    end
    # if no plaid items {trans: [], accounts: []}
    render json: {transactions: transactions, accounts: accounts}
  end

  # ohh this could be a Promise.all
  # but also i can make these two separate calls
  # call accounts, store acccounts, call transactions, store transactions
  def getTransactions(access_token, user)
    now = Date.today
    thirty_days_ago = (now - 30)
    begin
      product_response = @@client.transactions.get(access_token, thirty_days_ago, now)
      transactions = product_response.transactions.map do |transaction|  # map user into each transaction object 
        transaction[:user] = {username: user.username, id: user.id} # add a user key and set it to the owner
        transaction
      end
    rescue Plaid::PlaidAPIError => e
      error_response = format_error(e)
      transactions =  error_response
    end
    return transactions 
  end

  def getBalances(access_token, user)
    begin
      product_response = @@client.accounts.balance.get(access_token)
      balances = product_response.accounts.map do |account| 
        account[:user] = {username: user.username, id: user.id}
        account
      end
    rescue Plaid::PlaidAPIError => e
      error_response = format_error(e)
      balances = error_response
    end
    return balances
  end


  def format_error(err)
    { error: {
        error_code: err.error_code,
        error_message: err.error_message,
        error_type: err.error_type
      }
    }
  end

end