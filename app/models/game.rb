class Game < ActiveRecord::Base
  belongs_to :organization
  has_many :players
  has_many :users, through: :players

  hstore_accessor :options,
                  starve_time: :integer

  validates :starve_time, numericality: { only_integer: true, greater_than: 0 }
end
