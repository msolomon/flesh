class TagSerializer < ActiveModel::Serializer
  include SerializerMixin
  
  OZ = "Original Zombie"

  embed :ids

  attributes :id, :claimed, :source
  
  has_one :tagger
  has_one :taggee

  def tagger
    tagger_player = object.tagger
    if !is_me?(tagger_player.user) && tagger_player.is_stealthed?
      Player.new(id: 0, oz_status: :confirmed, user: User.new(screen_name: OZ, first_name: OZ, last_name: OZ, email: "flesh.io@monumentmail.com"))
    else
      tagger_player
    end
  end

end
