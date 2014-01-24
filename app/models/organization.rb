class Organization < ActiveRecord::Base
  has_many :user
  has_many :game
end
