require 'digest/md5'

class UserSerializer < ActiveModel::Serializer
  include SerializerMixin

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

  def include_email?
    is_user_me?
  end

  def phone
    is_user_me?
  end

  def authentication_token
    is_user_me?
  end

end
