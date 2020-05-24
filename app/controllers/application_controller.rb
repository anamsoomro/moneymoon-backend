class ApplicationController < ActionController::Base

  before_action :logged_in?

  def encode_token(payload) # payload is object of user_id
    JWT.encode(payload, "lilo") 
  end
  
  # now run this before all the pages 
  def logged_in? 
    headers = request.headers["Authorization"]  # get authorization: Bearer <token>
    token = headers.split(" ")[1] 
    begin 
      user_id = JWT.decode(token, "lilo")[0]["user_id"] # decode token to get that original payload object of user_id
      user = User.find(user_id) # find that user in db
    rescue 
      user = nil # if user not found, nil
    end
    render json: {error: "please log in!"} unless user # if a user wasnt found, womp
  end

  

end
