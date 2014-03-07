class Tag < ActiveRecord::Base
  include ModelMixin

  after_create :record_tag_event
  
  belongs_to :tagger, class_name: 'Player'
  belongs_to :taggee, class_name: 'Player'

  has_one :event_link, as: :eventable
  has_one :event, through: :event_link
  has_one :game, through: :tagger

  validates :claimed, presence: true
  validate :tagger_is_not_taggee

  def tagger_is_not_taggee
    errors[:base] << "You cannot tag yourself" if tagger == taggee
  end

  def game
    read_attribute(:game) || self.taggee.game unless self.taggee.nil?
  end

private

  def record_tag_event
    event = Event.create(event_type: :tag, data: {
      tag_id: self.id,
    })

    self.event = event
    self.game.events << event
    self.game.organization.events << event
    unless tagger.nil?
      self.tagger.events << event
      self.tagger.user.events << event
    end
    unless taggee.nil?
      self.taggee.user.events << event
      self.taggee.events << event
    end
  end

end
