class EventSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :event_type, :created_at,
    :user_id,
    :game_id,
    :organization_id,
    :player_id

  has_one :tag

  def tag
    Tag.find object.tag_id
  end

  def include_user_id?
    event_type_in [:join_flesh, :join_organization]
  end

  def include_game_id?
    event_type_in [:join_organization, :join_game]
  end

  def include_organization_id?
    event_type_in [:join_organization]
  end

  def include_player_id?
    event_type_in [:join_organization, :join_game]
  end

  def include_tag_id?
    event_type_in [:tag]
  end

  def include_tag?
    include_tag_id?
  end

  def event_type_in event_types
    event_types.include? object.event_type.to_sym
  end

end
