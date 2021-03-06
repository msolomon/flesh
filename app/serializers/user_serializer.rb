require 'digest/md5'

class UserSerializer < ActiveModel::Serializer
  include SerializerMixin
  embed :ids, include: true

  attributes :id,
             :screen_name,
             :email,
             :authentication_token,
             :avatar_url,
             :first_name,
             :last_name,
             :phone,
             :created_at,
             :active_player_id,
             :active_game_id,
             :player_ids

  has_many :players

  def avatar_url
    email_hash = Digest::MD5.hexdigest(object.email.downcase)
    "https://www.gravatar.com/avatar/#{email_hash}?d=retro&s=200"
  end

  def active_player_id
    object.active_player.id rescue nil
  end

  # TODO: make the clients deep dive through active player id instead
  def active_game_id
    object.active_player.game_id rescue nil
  end

  def include_email?
    is_user_me?
  end

  def include_phone?
    is_user_me?
  end

  def include_authentication_token?
    is_user_me?
  end

end
