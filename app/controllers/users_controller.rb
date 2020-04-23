class UsersController < ApplicationController

  skip_before_action :logged_in?, only: [:create] # no auth to sign up 

  skip_before_action :verify_authenticity_token # https://stackoverflow.com/questions/27098239/post-422-unprocessable-entity-in-rails-due-to-the-routes-or-the-controller

  def create 
    user = User.new(user_params) #create user object
    if user.valid? # check validations 
      user.save # its good, put it in the database 
      account = Account.create() # give them a new account
      user.update(account_id: account.id) # associate that account
      #later add conditional if joining an account
      render json: {
        username: user.username, 
        user_id: user.id,
        account_id: account.id, 
        token: encode_token({user_id: user.id}) # and give them a token authorizing them for the rest of app 
      }, status: :created
    else
      render json: {error: "Failed to create a user"}, status: :not_acceptable
    end
  end

  def index 
    users = User.all
    render json: users
  end

  private

  def user_params
    params.permit(:username, :password, :email)
  end

end
