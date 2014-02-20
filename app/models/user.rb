class User < ActiveRecord::Base
  include ModelMixin

  before_save :ensure_authentication_token

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

private
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def reset_authentication_token
    self.authentication_token = generate_authentication_token
  end

  def ensure_authentication_token
    if authentication_token.blank?
      reset_authentication_token
    end
  end

end
