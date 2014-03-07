class Organization < ActiveRecord::Base
  include ModelMixin
  
  has_many :games
  has_many :players, through: :games
  has_many :users, through: :players

  has_many :event_links, as: :eventable
  has_many :events, through: :event_links
end
