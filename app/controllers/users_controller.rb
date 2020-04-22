class UsersController < ApplicationController

  # not yet
  # skip_before_action :logged_in?, only: [:create] # you dont need auth to sign up 

  skip_before_action :verify_authenticity_token # https://stackoverflow.com/questions/27098239/post-422-unprocessable-entity-in-rails-due-to-the-routes-or-the-controller

  def create 
    user = User.new(user_params)
    if user.valid?
      user.save
      account = Account.create()
      user.update(account_id: account.id)
      #later add conditional if joining an account
      render json: {user: user, account: account}, status: :created
    else
      render json: {error: "Failed to create a user"}, status: :not_acceptable
    end
  end

  # Started POST "/users" for ::1 at 2020-04-22 16:07:21 -0500
  # Processing by UsersController#create as */*
  # Parameters: {"username"=>"dumdum", "password"=>"[FILTERED]", "email"=>"dumdum@yourmom.gmail.com", "user"=>{"username"=>"dumdum", "email"=>"dumdum@yourmom.gmail.com"}}
  # Completed 406 Not Acceptable in 11ms (Views: 0.3ms | ActiveRecord: 0.0ms | Allocations: 716)

  def index 
    users = User.all
    render json: users
  end

  private

  def user_params
    params.permit(:username, :password, :email)
  end

end
