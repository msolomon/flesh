class EventLink < ActiveRecord::Base
  include ModelMixin
  
  belongs_to :event
  belongs_to :eventable, polymorphic: true
end
