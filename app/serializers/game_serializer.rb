class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :organization_id, :timezone, :registration_start, :registration_end, :game_start, :game_end, :description, :oz_reveal, :starve_time, :player_ids
end
