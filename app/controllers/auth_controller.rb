class AuthController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create 
    # post request will have body with username and password
    user = User.find_by(username: params[:username])
    # if right, we give them a token encoded in application controller 
    byebug
    if user && user.authenticate(params[:password]) #authenticate method to check password against saved hash using bcrypt gem
      render json: {username: user.username, token: encode_token({user_id: user.id})}
    else 
      render json: {error: "invalid username or password"}
    end
  end

end
