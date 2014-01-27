class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  has_many :players
  has_many :games, through: :players
  has_many :organizations, through: :games

  validates :first_name, presence: true 
  validates :last_name, presence: true 
  # other fields validated by devise

end
