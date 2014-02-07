class EventLink < ActiveRecord::Base
  belongs_to :event
  belongs_to :eventable, polymorphic: true
end
