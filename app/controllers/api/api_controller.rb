class Api::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_filter :authenticate_user_from_token_soft

  def authenticate_user_from_token_soft
    user_id = params[:user_id].presence
    user = user_id && User.find_by_id(user_id)

    if user && Devise.secure_compare(user.authentication_token, auth_params[:authentication_token])
      sign_in(:user, user, store: false)
    else
      false
    end
  end

  def authenticate_user_from_token!
    if not authenticate_user_from_token_soft
      render json: string_to_error_document("Unauthorized. User id or authentication_token incorrect"), status: 401
    end
  end


  private
  def auth_params
    params.require(:user).permit(:authentication_token)
  end
end