require 'obscenity'
require 'securerandom'

class Player < ActiveRecord::Base
  include ModelMixin

  before_validation :ensure_human_code

  after_create :record_join_event

  enum oz_status: [:uninterested, :interested, :unconfirmed, :confirmed]

  belongs_to :user
  belongs_to :game

  has_many :tags, foreign_key: 'tagger_id'
  has_many :taggees, class_name: 'Player', through: :tags

  has_one :tagged_tag, class_name: 'Tag', foreign_key: 'taggee_id'
  has_one :tagger, class_name: 'Player', through: :tagged_tag, foreign_key: 'tagger_id'

  has_many :event_links, as: :eventable
  has_many :events, through: :event_links

  default_scope { order(id: :asc) }


  def canTag?
    return [:oz, :zombie].include? true_status
  end

  def canBeTagged?
    true_status == :human
  end

  def confirmedOZ?
    oz_status.to_sym == :confirmed
  end

  def is_stealthed?
    true_status == :oz && !game.oz_revealed?
  end

  def true_status
    status = :human

    if oz_status.to_sym == :confirmed then
      status = :oz
    elsif tagged_tag != nil then
      status = :zombie
    end

    unless status == :human || (last_fed && [Time.now, game.game_end].min < starve_time) then
      status = :starved
    end

    status
  end

  def starve_time
    last_fed + game.starve_time
  end

  def last_fed
    most_recent_feeding = tags.order(claimed: :desc).first

    if most_recent_feeding == nil

      if oz_status.to_sym == :confirmed then
        most_recent_feeding = game.game_start
      elsif tagged_tag then
        most_recent_feeding = tagged_tag.claimed
      end

    elsif most_recent_feeding
      most_recent_feeding.claimed
    end

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

  def record_join_event
    unless self.user.games.where.not(id: self.game.id).pluck(:organization_id).include? self.game.organization.id
      join_organization_event = Event.create(event_type: :join_organization, data: {
        user_id: self.user.id,
        game_id: self.game.id,
        organization_id: self.game.organization,
        player_id: self.id
      })

      self.user.events << join_organization_event
      self.game.organization.events << join_organization_event
    end

    join_game_event = Event.create(event_type: :join_game, data: {
      player_id: self.id,
      game_id: self.game_id
    })

    self.events << join_game_event
    self.user.events << join_game_event
    self.game.events << join_game_event
    self.game.organization.events << join_game_event
  end

end
