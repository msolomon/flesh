class Tag < ActiveRecord::Base
  include ModelMixin
  
  belongs_to :tagger, class_name: 'Player'
  belongs_to :taggee, class_name: 'Player'

  has_one :event_link, as: :eventable
  has_one :event, through: :event_link

  validates :claimed, presence: true
  validate :tagger_is_not_taggee

  def tagger_is_not_taggee
    errors[:base] << "You cannot tag yourself" if tagger == taggee
  end

end
