class TagSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :claimed
  
  has_one :tagger
  has_one :taggee

  def tagger
    tagger_player = object.tagger
    if tagger_player.is_stealthed?
      Player.new(id: 0)
    else
      tagger_player
    end
  end

end
