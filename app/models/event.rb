class Event < ActiveRecord::Base
  include ModelMixin

  enum event_type: [
    :unknown,
    :join_flesh,
    :join_organization,
    :join_game,
    :tag
  ]
  
  has_many :event_links
end
