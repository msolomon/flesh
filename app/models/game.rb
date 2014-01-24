class Game < ActiveRecord::Base
  belongs_to :organization
  has_many :player
  has_many :user, through: :player
end
