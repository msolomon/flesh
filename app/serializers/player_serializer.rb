require 'memoist'

class PlayerSerializer < ActiveModel::Serializer
  extend Memoist
  include SerializerMixin
  embed :ids, include: true

  attributes :id, :user_id, :game_id, :status, :last_fed, :oz_status, :human_code
  has_one :user

  def status
    if memoized_true_status == :oz then
      if is_me?(object.user) || object.game.oz_revealed? then
        :zombie
      else
        :human
      end
    else
      memoized_true_status
    end
  end

  def include_human_code?
    is_me?(object.user) && memoized_true_status == :human
  end

  def include_last_fed?
    status == :zombie
  end

  def include_oz_status?
    is_me?(object.user)
  end

  def memoized_true_status
    object.true_status
  end
  memoize :memoized_true_status

end
