require 'digest/md5'

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
    email_hash = Digest::MD5.hexdigest(object.email.downcase.gsub(/\w/, ''))
    "http://www.gravatar.com/avatar/#{email_hash}"
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
