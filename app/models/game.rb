class Game < ActiveRecord::Base
  belongs_to :organization
  has_many :players
  has_many :users, through: :players
end
