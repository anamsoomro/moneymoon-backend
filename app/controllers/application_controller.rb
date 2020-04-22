class ApplicationController < ActionController::Base


  # whats the poinit of keepingi this here instead of at login 
  def encode_token(payload)
    # payload brings in the user_id
    JWT.encode(payload, "lilo") # can put an optional algo if dont want to use "HS256"
  end
  
  # now run this before all the pages 
  def logged_in? 
    headers = request.headers["Authorization"]
    token = headers.split(" ")[1]
    begin 
      user_id = JWT.decode(token, "lilo")[0]["user_id"]
      user = User.find(user.id)
    rescue 
      user = nil
    end
    render json: {error: "please log in!"} unless user
  end

  

end
