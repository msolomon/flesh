class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :location, :timezone, :description, :created_at, :game_ids, :user_ids
end
