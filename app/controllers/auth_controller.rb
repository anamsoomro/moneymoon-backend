class AuthController < ApplicationController

  skip_before_action :verify_authenticity_token
  skip_before_action :logged_in?, only: [:create] 


  def create 
    user = User.find_by(username: params[:username]) # find the user
    if user && user.authenticate(params[:password]) # auth method from bcrypt to check password against saved hash
      account = user.account
      render json: {
        user: {username: user.username, id: user.id},
        account: {id: account.id, code: account.code, users: account.users}, 
        token: encode_token({user_id: user.id}) # and give them a token authorizing them for the rest of app 
      }
    else 
      render json: {error: "wrong credentials, please try again"}
    end
  end

end
