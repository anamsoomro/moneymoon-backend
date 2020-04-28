require 'securerandom'

class UsersController < ApplicationController

  skip_before_action :logged_in?, only: [:create] # no auth to sign up 
  skip_before_action :verify_authenticity_token # https://stackoverflow.com/questions/27098239/post-422-unprocessable-entity-in-rails-due-to-the-routes-or-the-controller

  def create 
    if params['account_code'] == "" # if no code, make them a new account
      account = Account.create({code: SecureRandom.uuid})
    elsif params['account_code'] != "" # if have a code find that account
      account = Account.find_by(code: params['account_code'])
      unless account 
        render json: {error: "that account id was not found"} # THIS DOESNT RENDER AND IT KEEPS READING
      end
    end
    user = User.new({username: user_params['username'], password: user_params['password'], email: user_params['email'], account_id: account.id}) # make user object 
    if user.valid? 
      user.account_id = account.id # link it with account
      user.save # save it to db
      render json: {
        user: {username: user.username, id: user.id},
        account: {id: account.id, code: account.code, users: account.users}, #UH OH info load
        token: encode_token({user_id: user.id}) # and give them a token authorizing them for the rest of app 
      }, status: :created
    else
      render json: user.errors.messages, status: :not_acceptable
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
