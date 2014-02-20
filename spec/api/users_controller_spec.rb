require 'spec_helper'

describe "User API" do

  it 'cant signup if user exists' do
    user_params = FactoryGirl.attributes_for(:user)
    User.create! user_params

    post api_users_path, user: user_params

    expect(response.response_code).to eq(422)
  end

  it 'cant signup without first name' do
    user_params = FactoryGirl.attributes_for(:user)
    
    user_params.delete(:first_name)
    
    expect {post api_users_path, user: user_params}.to raise_error(ActionController::ParameterMissing)
  end

  it "can't signup with the same email using a different case" do
    user_params = FactoryGirl.attributes_for(:user)
    user_params[:email].downcase!
    post api_users_path, user: user_params
    expect(response.response_code).to eq(201)

    user_params[:email].upcase!
    post api_users_path, user: user_params
    expect(response.response_code).to eq(422)
  end

  it 'gets complete user object on signup' do
    user_params = FactoryGirl.attributes_for(:user)

    puts "@@#{api_users_path}"
    post api_users_path user: user_params

    expect(response.response_code).to eq(201)

    user = get_json['user']

    expect(user.keys.map{|key| key.to_sym}).to include(:email, :first_name, :last_name, :email, :id, :authentication_token)
    expect(user['first_name']).to eq(user_params[:first_name])
    expect(user['last_name']).to eq(user_params[:last_name])
    expect(user['email']).to eq(user_params[:email])
  end

  it 'gets complete user object on login' do
    user_params = FactoryGirl.attributes_for(:user)
    user = User.create(user_params)

    post api_users_login_path, user: user_params

    expect(get_json['user'].presence).not_to eq(nil)
    expect(get_json['user'].keys.map{|key| key.to_sym}).to include(:email, :first_name, :last_name, :email, :id, :authentication_token)
    expect(user.first_name).to eq(user_params[:first_name])
    expect(user.last_name).to eq(user_params[:last_name])
    expect(user.email).to eq(user_params[:email])
  end

  # it 'allows password reset with just email' do
  #   user_params = FactoryGirl.attributes_for(:user)
  #   user = User.create(user_params)

  #   post reset_password_api_users_path, user: user_params

  #   expect(get_json['message'].presence).not_to eq(nil)
  # end

  # it 'rejects password reset without email' do
  #   user_params = FactoryGirl.attributes_for(:user)
  #   user = User.create(user_params)

  #   expect{post reset_password_api_users_path}.to raise_error(ActionController::ParameterMissing)
  # end

  it 'returns the current user on show' do
    authenticate_user

    user = FactoryGirl.create(:user)

    get api_users_path, {
      user: { 
        authentication_token: user.authentication_token
      },
      user_id: user.id
    }

    expect(response.response_code).to eq(200)
  end

  it 'can login with a capitalized email' do
    email = "TEST@example.com"

    user = FactoryGirl.build(:user)
    user.email = email.downcase
    user.save

    user_params = FactoryGirl.attributes_for(:user)
    user_params[:email] = email

    post api_users_login_path, user: user_params

    expect(response.response_code).to eq(200)
  end
end