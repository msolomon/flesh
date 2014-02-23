require 'spec_helper'

describe "User API" do

  let(:user_params) {FactoryGirl.attributes_for(:user).deep_dup}
  let(:user) {FactoryGirl.create(:user)}

  def create_user
    user
  end

  def ieq string_arg
    match(%r{#{string_arg}}i)
  end

  it 'cant signup if user exists' do
    create_user

    post api_users_path, user: user_params

    expect(response.response_code).to eq(422)
    expect(get_json.keys.map{|key| key.to_sym}).to include(:error, :errors)
  end

  it 'cant signup without first name' do
    incomplete_user_params = user_params

    incomplete_user_params.delete(:first_name)

    expect{post api_users_path, user: incomplete_user_params}.to raise_error(ActionController::ParameterMissing)
  end

  it 'can signup with empty phone' do
    incomplete_user_params = user_params

    incomplete_user_params[:phone] = ""

    post api_users_path, user: incomplete_user_params
    expect(response.response_code).to eq(201)
  end

  it "can't signup with the same email using a different case" do
    downcased_user_params = user_params.deep_dup
    downcased_user_params[:email].downcase!
    post api_users_path, user: downcased_user_params
    expect(response.response_code).to eq(201)

    upcased_user_params = user_params.deep_dup()
    upcased_user_params[:email].upcase!
    post api_users_path, user: upcased_user_params
    expect(response.response_code).to eq(422)
  end

  it 'gets complete user object on signup' do
    post api_users_path user: user_params

    expect(response.response_code).to eq(201)

    expect_complete_user get_json['user'], user_params
  end

  def expect_complete_user(user_json, user_params)
    expect(user_json).not_to eq(nil)
    expect(user_json.keys.map{|key| key.to_sym}).to include(:id,
                                                            :screen_name,
                                                            :first_name,
                                                            :last_name,
                                                            :phone,
                                                            :email,
                                                            :authentication_token,
                                                            :created_at)
    expect(user_json['id']).not_to eq(nil)
    expect(user_json['screen_name']).to eq(user_params[:screen_name])
    expect(user_json['first_name']).to eq(user_params[:first_name])
    expect(user_json['last_name']).to eq(user_params[:last_name])
    expect(user_json['email']).to ieq(user_params[:email])
    expect(user_json['authentication_token']).not_to eq(nil)
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
    create_user

    get api_user_path(user), nil, user_auth_header(user)

    expect(response.response_code).to eq(200)
    expect_complete_user get_json['user'], user_params
  end

  it 'can login with a capitalized email' do
    create_user

    user_login_params = {
      email: user_params[:email].upcase,
      password: user_params[:password]
    }

    post api_user_login_path, user: user_login_params

    expect(response.response_code).to eq(200)
    expect_complete_user get_json['user'], user_params
  end

  it 'gets complete user object on login' do
    this_user = user

    user_login_params = {
      email: user_params[:email],
      password: user_params[:password]
    }

    post api_user_login_path, user: user_login_params

    expect_complete_user get_json['user'], user_params
  end

  it 'cannot read private fields of other users' do
    this_user = create_user
    get api_user_path(this_user)

    expect_filtered_user get_json['user']
  end

  it 'filters each user as appropriate' do
    first = user
    second = FactoryGirl.create(:user, {email: '2@gmail.COM', screen_name: 'skeletor'})

    get api_users_path, nil, user_auth_header(first)

    expect_complete_user get_json['users'].select {|u| u['id'] == first.id}.first, user_params
    expect_filtered_user get_json['users'].select {|u| u['id'] == second.id}.first
  end

  def expect_filtered_user user_json
    expect(response.response_code).to eq(200)
    expect(user_json['id']).not_to eq(nil)
    expect(user_json['email']).to eq(nil)
    expect(user_json['phone']).to eq(nil)
    expect(user_json['authentication_token']).to eq(nil)
  end

end
