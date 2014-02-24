class Game < ActiveRecord::Base
  include ModelMixin
  
  belongs_to :organization
  has_many :players
  has_many :users, through: :players

  hstore_accessor :options,
                  starve_time: :integer,
                  oz_reveal: :time

  validates :starve_time, numericality: { only_integer: true, greater_than: 0 }
  validates :oz_reveal, oz_reveal: true

  def oz_revealed?
    oz_reveal <= Time.now
  end

  def running?
    game_start <= Time.now && Time.now <= game_end
  end

  def running_error_string
    if game_start > Time.now
      "The game has not yet begun"
    elsif game_end < Time.now
      "The game has already ended"
    end
  end

  def registration_open?
    registration_start <= Time.now && Time.now <= registration_end
  end

  def registration_open_error_string
    if registration_start > Time.now
      "The registration period has not yet begun"
    elsif registration_end < Time.now
      "The registration period has already ended"
    end
        
  end
  
end
