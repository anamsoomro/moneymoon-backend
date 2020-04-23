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
    user = User.find(params['user_id'])
    pi = PlaidItem.create({
      p_access_token: @@access_token,
      user_id: user.id,
      p_item_id: @@item_id
    })

    # get transactions
    now = Date.today
    thirty_days_ago = (now - 30)
    begin
      product_response = @@client.transactions.get(@@access_token, thirty_days_ago, now)
      render json: product_response
    rescue Plaid::PlaidAPIError => e
      error_response = format_error(e)
      render json: error_response
    end

    # render json: pi
    # "{"access_token":"access-sandbox-35cda5a6-fa6e-4aab-96ae-7c7d2e182533","item_id":"X49RJrkwmEhkMxD8brZyhznPWzgdL8fdKpxBX","request_id":"RfhSal2vZKKEkc7"}"
  end

  # def getTransactions
  #   now = Date.today
  #   thirty_days_ago = (now - 30)
  #   begin
  #   product_response = @@client.transactions.get(@@access_token, thirty_days_ago, now)
  #   render json: product_response
  #   rescue Plaid::PlaidAPIError => e
  #   error_response = format_error(e)
  #   render json: error_response
  #   end
  # end


  def format_error(err)
    { error: {
        error_code: err.error_code,
        error_message: err.error_message,
        error_type: err.error_type
      }
    }
  end

end