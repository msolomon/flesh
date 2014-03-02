class TagSerializer < ActiveModel::Serializer
  attributes :id, :claimed
  has_one :tagger
  has_one :taggee
  # todo: filter tagger if unrevealed oz
end
