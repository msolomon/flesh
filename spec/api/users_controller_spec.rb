require 'spec_helper'

describe "User API" do

  let(:user_params) {FactoryGirl.attributes_for(:user).deep_dup}
  let(:user) {FactoryGirl.create(:user).deep_dup}
  let(:user_auth_header) {get_auth_header(nil, nil).deep_dup}

  def create_user
    user
  end

  def ieq string_arg
    match(%r{#{string_arg}}i)
  end

  it 'cant signup if user exists' do
    create_user

    post api_users_path, user: user_params, format: :json

    expect(response.response_code).to eq(422)
    expect(get_json.keys.map{|key| key.to_sym}).to include(:error, :errors)
  end

  it 'cant signup without first name' do
    incomplete_user_params = user_params

    incomplete_user_params.delete(:first_name)

    expect{post api_users_path, user: incomplete_user_params, format: :json}.to raise_error(ActionController::ParameterMissing)
  end

  it 'can signup with empty phone' do
    incomplete_user_params = user_params

    incomplete_user_params[:phone] = ""

    post api_users_path, user: incomplete_user_params, format: :json
    expect(response.response_code).to eq(201)
  end

  it "can't signup with the same email using a different case" do
    downcased_user_params = user_params.deep_dup
    downcased_user_params[:email].downcase!
    post api_users_path, user: downcased_user_params, format: :json
    expect(response.response_code).to eq(201)

    upcased_user_params = user_params.deep_dup()
    upcased_user_params[:email].upcase!
    post api_users_path, user: upcased_user_params, format: :json
    expect(response.response_code).to eq(422)
  end

  it 'gets complete user object on signup' do
    post api_users_path user: user_params, format: :json

    expect(response.response_code).to eq(201)

    user_json = get_json['user']
    expect_complete_user user_json
  end

  it 'gets complete user object on login' do
    this_user = user

    user_login_params = {
      email: user_params[:email],
      password: user_params[:password]
    }

    post api_user_login_path, user: user_login_params, format: :json

    user_json = get_json['user']
    expect_complete_user user_json
  end

  def expect_complete_user user_json
    expect(user_json).not_to eq(nil)
    expect(user_json.keys.map{|key| key.to_sym}).to include(:id,
                                                            :first_name,
                                                            :last_name,
                                                            :phone,
                                                            :email,
                                                            :authentication_token,
                                                            :created_at)
    expect(user_json['id']).not_to eq(nil)
    expect(user_json['first_name']).to eq(user_params[:first_name])
    expect(user_json['last_name']).to eq(user_params[:last_name])
    expect(user_json['email']).to ieq(user_params[:email])
    expect(user_json['authentication_token']).not_to eq(nil)
  end
  # it 'allows password reset with just email' do
  #   user_params = FactoryGirl.attributes_for(:user)
  #   user = User.create(user_params)

  #   post reset_password_api_users_path, user: user_params, format: :json

  #   expect(get_json['message'].presence).not_to eq(nil)
  # end

  # it 'rejects password reset without email' do
  #   user_params = FactoryGirl.attributes_for(:user)
  #   user = User.create(user_params)

  #   expect{post reset_password_api_users_path}.to raise_error(ActionController::ParameterMissing)
  # end

  it 'returns the current user on show' do
    create_user

    get api_users_path, nil, user_auth_header

    expect(response.response_code).to eq(200)
  end

  # it 'can login with a capitalized email' do
  #   email = "TEST@example.com"

  #   downcased_user = user.deep_dup
  #   downcased_user.email = email.downcase
  #   downcased_user.save

  #   downcased_user_params = user_params.deep_dup
  #   downcased_user_params[:email] = email

  #   post api_users_login_path, user_auth_header, user: downcased_user_params

  #   expect(response.response_code).to eq(200)
  # end

end