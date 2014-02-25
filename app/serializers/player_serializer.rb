class PlayerSerializer < ActiveModel::Serializer
  include SerializerMixin

  attributes :id, :user_id, :game_id, :status, :last_fed, :oz_status

  def status
    if object.true_status == :oz then
      if object.user == current_user || object.game.oz_revealed? then
        :zombie
      else
        :human
      end
    else
      object.true_status
    end
  end

  def last_fed
    status == :zombie ? object.last_fed : nil
  end

  def oz_status
    if object.user == current_user
      object.oz_status
    end
  end
end
