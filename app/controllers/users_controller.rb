 class UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:show]

  def register
    passhash = Digest::SHA1.hexdigest(params[:password])
    @user = User.new(username: params[:username], full_name: params[:full_name],
                     email: params[:email], home_address: params[:home_address], password: passhash)
    if @user.save
      render json: { user: @user.as_json(only: [:id, :username, :full_name,
                     :email, :home_address, :access_token]) },
        status: :created
    else
      render json: { errors: @user.errors.full_messages },
        status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(username: params[:username])
    passhash = Digest::SHA1.hexdigest(params[:password])
    if @user && passhash == @user.password
      render json: {user: @user.as_json(only: [:id, :username, :email, :access_token]) },
        status: :created
    else
      render json: { message: "Invalid login or password." },
        status: :unauthorized
    end
  end


  def show
    @user = User.find_by(username: params[:username])
    render json: {user: @user.as_json(only: [:id, :full_name, :username, :email, :home_address])}
  end

  

  # def delete
  #   @user = User.find_by(username: params[:username])
  #   if current_user.access_token == @user.access_token
  #     @user.destroy
  #     render json: { message: "Account deleted." }, status: :no_content
  #   else
  #     render json: { message: "You are not authorized to delete this account!" }, 
  #       status: :unauthorized
  #   end
  # end 
