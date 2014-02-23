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

  def user_auth_header user_object
    {
      'Authorization' => 'Basic ' + Base64.strict_encode64("#{user_object.id}:#{user_object.authentication_token}"),
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

end
