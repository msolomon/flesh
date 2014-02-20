require "base64"

module ControllerMacros

  def authenticate_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the confirmable module
      sign_in user
    end
  end

  def get_auth_header(id, authentication_token)
    user_params = FactoryGirl.attributes_for(:user)
    id = id || user_params[:id]
    authentication_token = authentication_token || user_params[:authentication_token]

    {'Authorization' => 'Basic ' + Base64.strict_encode64("#{id}:#{authentication_token}")}
  end

end
