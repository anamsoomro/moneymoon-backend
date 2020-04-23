require 'date'

class PlaidController < ApplicationController

  skip_before_action :verify_authenticity_token # https://stackoverflow.com/questions/27098239/post-422-unprocessable-entity-in-rails-due-to-the-routes-or-the-controller

  # i think im suppose to put that somewhere else 
  @@client = Plaid::Client.new(env: :sandbox,
                             client_id: "5e9b96c18a49a900129cd1f3",
                             secret: "513e54a8369a1359eea03efcdca830",
                             public_key: "38e9fa8478f20a384db53c1176e9b7")

  @@access_token = nil

  @@item_id = nil


  def getAccessToken 
    exchange_token_response = @@client.item.public_token.exchange(params['public_token'])
    @@access_token = exchange_token_response['access_token']
    @@item_id = exchange_token_response['item_id']

    #  everytime you link it, it gives a new access token a new item_id?? y
    # "{"access_token":"access-sandbox-35cda5a6-fa6e-4aab-96ae-7c7d2e182533","item_id":"X49RJrkwmEhkMxD8brZyhznPWzgdL8fdKpxBX","request_id":"RfhSal2vZKKEkc7"}"
    user = User.find(params['user_id'])
    pi = PlaidItem.create({
      p_access_token: @@access_token,
      user_id: user.id,
      p_item_id: @@item_id
    })

    # get last 30 days of transactions from all accounts in item
    now = Date.today
    thirty_days_ago = (now - 30)
    begin
      product_response = @@client.transactions.get(@@access_token, thirty_days_ago, now)
      # render json: product_response
      transactions = product_response
    rescue Plaid::PlaidAPIError => e
      error_response = format_error(e)
      # render json: error_response
      transactions = error_response
    end

    #get balances for each account of an item
    begin
      product_response = @@client.accounts.balance.get(@@access_token)
      # pretty_print_response(product_response)
      # content_type :json
      # { balance: product_response }.to_json
      accounts = product_response
    rescue Plaid::PlaidAPIError => e
      error_response = format_error(e)
      # pretty_print_response(error_response)
      # content_type :json
      # error_response.to_json
      accounts = error_response
    end

    render json: {transactions: transactions, accounts: accounts}
  end

  def getTransactions
    now = Date.today
    thirty_days_ago = (now - 30)
    begin
    product_response = @@client.transactions.get(@@access_token, thirty_days_ago, now)
    render json: product_response
    rescue Plaid::PlaidAPIError => e
    error_response = format_error(e)
    render json: error_response
    end
  end

  def getBalances
    # THIS DOESNT HAVE A ROUTE. ITS FOR REF RIGHT NOW 
    begin
      product_response = @@client.accounts.balance.get(@@access_token)
      # pretty_print_response(product_response)
      # content_type :json
      # { balance: product_response }.to_json
      render json: product_response
    rescue Plaid::PlaidAPIError => e
      error_response = format_error(e)
      # pretty_print_response(error_response)
      # content_type :json
      # error_response.to_json
      render json: error_response
    end
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