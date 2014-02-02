class Tag < ActiveRecord::Base
  belongs_to :tagger, class_name: 'Player'
  belongs_to :taggee, class_name: 'Player'
end
