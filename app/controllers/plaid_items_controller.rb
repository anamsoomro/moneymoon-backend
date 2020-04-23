class PlaidItemsController < ApplicationController

  skip_before_action :logged_in?, only: [:index] # because I want to see them

  def index 
    pi = PlaidItem.all 
    render json: pi
  end
  
end
