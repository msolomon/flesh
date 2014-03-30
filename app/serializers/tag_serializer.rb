class TagSerializer < ActiveModel::Serializer
  include SerializerMixin

  embed :ids

  attributes :id, :claimed, :source
  
  has_one :tagger
  has_one :taggee

  def tagger
    tagger_player = object.tagger
    if !is_me?(tagger_player.user) && tagger_player.is_stealthed?
      Player.new(id: 0)
    else
      tagger_player
    end
  end

end
