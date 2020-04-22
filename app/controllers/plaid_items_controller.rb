class PlaidItemsController < ApplicationController

  def index 
    pi = PlaidItem.all 
    render json: pi
  end
  
end
