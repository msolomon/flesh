class UserSerializer < ActiveModel::Serializer
  include SerializerMixin

  # TODO: filter phone and email for authorized users
  attributes :id,
             :screen_name,
             :email,
             :authentication_token,
             :avatar_url,
             :first_name,
             :last_name,
             :phone,
             :created_at


  def avatar_url
    # TODO: include this (gravatar to start)
    nil
  end

  def email
    nil_if_not_me object.email
  end

  def phone
    nil_if_not_me object.phone
  end

  def authentication_token
    nil_if_not_me object.authentication_token
  end

end
