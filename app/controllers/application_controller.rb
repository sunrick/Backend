class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def current_user
    token = request.headers['Access-Token']
    token && User.find_by(access_token: token)
  end

  def authenticate_with_token!
    unless current_user
      render json: { message: "Access-Token not found." },
                    status: :unauthorized
    end
  end
end
