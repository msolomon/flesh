class Organization < ActiveRecord::Base
  has_many :games
  has_many :players, through: :games
  has_many :users, through: :players
end
