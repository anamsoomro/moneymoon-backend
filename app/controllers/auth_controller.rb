class AuthController < ApplicationController

  skip_before_action :verify_authenticity_token
  skip_before_action :logged_in?, only: [:create] # no auth to sign in 


  def create 
    # post request will have body with username and password
    user = User.find_by(username: params[:username]) # find the user
    if user && user.authenticate(params[:password]) # auth method from bcrypt to check password against saved hash
      # data = getAccountData(user)
      #hm i cant call that function in here. its not in app controller
      # byebug
      render json: {
        username: user.username, 
        user_id: user.id, 
        account_id: user.account_id,
        # data: data, # get transactions and accounts related all their accounts plaid items
        token: encode_token({user_id: user.id}) # and give them a token authorizing them for the rest of app 
      }
    else 
      render json: {error: "invalid username or password"}
    end
  end

end
