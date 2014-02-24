class Event < ActiveRecord::Base
  include ModelMixin
  
  has_many :event_links
end
