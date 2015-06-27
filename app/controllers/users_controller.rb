 class UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:show]

  def register
    passhash = Digest::SHA1.hexdigest(params[:password])
    @user = User.new(username: params[:username], full_name: params[:full_name],
                     email: params[:email], password: passhash)
    if @user.save
      render 'register.json.jbuilder', status: :created
    else
      render json: { errors: @user.errors.full_messages },
        status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(username: params[:username])
    passhash = Digest::SHA1.hexdigest(params[:password])
    if @user && passhash == @user.password
      render 'login.json.jbuilder', status: :ok 
    else
      render json: { message: "The username or password you supplied is incorrect." },
        status: :unauthorized
    end
  end


  def show
    @user = User.find_by(username: params[:username])
    render json: {user: @user.as_json(only: [:id, :full_name, :username, :email, :home_address])}
  end

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
