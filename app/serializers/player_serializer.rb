class PlayerSerializer < ActiveModel::Serializer
  include SerializerMixin
  
  attributes :id, :user_id, :game_id, :created_at
end
