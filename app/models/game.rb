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
  
end
