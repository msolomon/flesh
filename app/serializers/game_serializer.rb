class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :organization_id, :timezone, :registration_start, :registration_end, :game_start, :game_end, :description, :player_ids
end
