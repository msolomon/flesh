require "base64"

class Api::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  before_filter :authenticate_user_from_token_soft

  def authenticate_user_from_token_soft
    auth_data = auth_params
    user_id = auth_data[:user_id]
    user = user_id && User.find_by_id(user_id)

    if user && Devise.secure_compare(user.authentication_token, auth_data[:authentication_token])
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

  def respond_with_error_string(error)
      render json: string_to_error_document(error), status: 422
  end

  def respond_with_error_document(model)
      render json: model.to_error_document, status: 422
  end

private
  def auth_params
    params = {user_id: nil, authentication_token: nil}

    auth_field = request.headers['Authorization']
    if auth_field
      auth_field = auth_field[6..-1]
    end

    if auth_field
      fields = Base64.decode64(auth_field).split(':')
      if fields.length == 2
        params = {user_id: fields[0], authentication_token: fields[1]}
      end
    end

    params
  end

end
