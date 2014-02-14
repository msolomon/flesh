require 'obscenity'
require 'SecureRandom'

class Player < ActiveRecord::Base
  before_validation :ensure_human_code

  enum oz_status: [:uninterested, :interested, :unconfirmed, :confirmed]

  belongs_to :user
  belongs_to :game

  has_many :tags, foreign_key: 'tagger_id'
  has_many :taggees, class_name: 'Player', through: :tags

  has_one :tagged_tag, class_name: 'Tag', foreign_key: 'taggee_id'
  has_one :tagger, class_name: 'Player', through: :tagged_tag, foreign_key: 'tagger_id'

  has_many :event_links, through: :taggable
  has_many :events, through: :event_links

  def canTag?
    # TODO: implement
    return false
  end

  def canBeTagged?
    # TODO: implement
    return false
  end

private
  def add_human_code
    loop do
      self.human_code = generate_random_human_code
      break if !Obscenity.profane? self.human_code and !Player.where(human_code: self.human_code).exists?
    end
  end

  def generate_random_human_code
    'abcdefghjkmnpqrstuvwxyz23456789'.split('').shuffle(random: SecureRandom.random_number)[0,5].join
  end

  def ensure_human_code
    if human_code.blank?
      add_human_code
    end
  end

end
