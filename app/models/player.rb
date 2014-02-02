require 'obscenity'
require 'SecureRandom'

class Player < ActiveRecord::Base
  before_validation :add_human_code

  belongs_to :user
  belongs_to :game

  enum oz_status: [:uninterested, :interested, :unconfirmed, :confirmed]


private
  def add_human_code
    loop do
      self.human_code = generate_random_human_code
      break if !Obscenity.profane? self.human_code
    end
  end

  def generate_random_human_code
    'abcdefghjkmnpqrstuvwxyz23456789'.split('').shuffle(random: SecureRandom.random_number)[0,5].join
  end

end
