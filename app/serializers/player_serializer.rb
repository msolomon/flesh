class PlayerSerializer < ActiveModel::Serializer
  include SerializerMixin
  embed :ids, include: true

  attributes :id, :user_id, :game_id, :status, :last_fed, :oz_status, :human_code
  has_one :user

  def status
    if object.true_status == :oz then
      if is_me?(object.user) || object.game.oz_revealed? then
        :zombie
      else
        :human
      end
    else
      object.true_status
    end
  end

  def include_human_code?
    is_me?(object.user)
  end

  def include_last_fed?
    status == :zombie
  end

  def include_oz_status?
    is_me?(object.user)
  end

end
