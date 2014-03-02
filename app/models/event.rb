class Event < ActiveRecord::Base
  include ModelMixin

  default_scope { distinct }

  enum event_type: [
    :unknown,
    :join_flesh,
    :join_organization,
    :join_game,
    :tag
  ]

  hstore_accessor :data,
                  tag_id: :integer,
                  user_id: :integer,
                  game_id: :integer,
                  organization_id: :integer,
                  player_id: :integer

  has_many :event_links
end
