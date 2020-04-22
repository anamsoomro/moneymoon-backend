class PlaidAccountsController < ApplicationController

  def index 
    pa = PlaidAccount.all 
    render json: pa
  end
end
