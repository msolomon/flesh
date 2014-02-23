class UserSerializer < ActiveModel::Serializer
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
    nil
  end

  def email
    nil_if_not_current object.email
  end

  def phone
    nil_if_not_current object.phone
  end

  def authentication_token
    nil_if_not_current object.authentication_token
  end

  def nil_if_not_current field
    is_current_user? ? field : nil
  end

  def is_current_user?
    object == current_user
  end

end
