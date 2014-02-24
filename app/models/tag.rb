class Tag < ActiveRecord::Base
  include ModelMixin
  
  belongs_to :tagger, class_name: 'Player'
  belongs_to :taggee, class_name: 'Player'

  validates :claimed, presence: true
  validate :tagger_is_not_taggee

  def tagger_is_not_taggee
    errors[:base] << "You cannot tag yourself" if tagger == taggee
  end

end
