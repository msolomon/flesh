class Api::SessionsController < Api::ApiController
  include ApplicationHelper
  before_filter :authenticate_user_from_token!
  skip_before_filter :authenticate_user_from_token!, only: [:create]

  def create
    user = User.find_for_database_authentication(email: user_params[:email])

    return invalid_login_attempt unless user and user.valid_password?(user_params[:password])

    sign_in(:user, user, store: false)
    respond_with(:api, user, status: :ok)
  end

  def destroy
    current_user.reset_authentication_token
    current_user.save!
    respond_with(:api, nil, status: :no_content)
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end

  def invalid_login_attempt
    render json: string_to_error_document("User with that email and password not found"), status: :unauthorized
  end
end
