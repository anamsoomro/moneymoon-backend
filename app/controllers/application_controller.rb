class ApplicationController < ActionController::Base

  # before_action :logged_in?

  def encode_token(payload) # payload is object of user_id
    JWT.encode(payload, "lilo") # can put an optional algo if dont want to use "HS256"
  end
  
  # now run this before all the pages 
  # this needs way more work
  def logged_in? 
    headers = request.headers["Authorization"]
    token = headers.split(" ")[1] # NoMethodError (undefined method `split' for nil:NilClass):
    begin 
      user_id = JWT.decode(token, "lilo")[0]["user_id"]
      user = User.find(user.id)
    rescue 
      user = nil
    end
    render json: {error: "please log in!"} unless user
    render json: {error: "please log in!"} unless user
  end

  

end
