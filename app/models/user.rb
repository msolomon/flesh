class User < ActiveRecord::Base
  include ModelMixin

  before_validation :reformat_phone
  before_save :ensure_authentication_token

  after_create :record_join_event

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  has_many :players
  has_many :games, through: :players
  has_many :organizations, through: :games

  has_many :event_links, as: :eventable
  has_many :events, through: :event_links

  validates :screen_name, length: {in: 3..20}, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true 
  validates :last_name, presence: true 
  validates :phone, phone: :true
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

  def reformat_phone
    return if self.phone == nil
    
    numbers_only = self.phone.gsub /\D/, ''

    case numbers_only.length
    when 0
      self.phone = nil
    when 10
      # assume American if given 10 digits
      self.phone = "+1#{numbers_only}"
    else
      self.phone = "+#{numbers_only}"
    end
  end

  def record_join_event
    event = Event.create(event_type: :join_flesh, data: {
      user_id: self.id
    })

    self.events << event
  end

end
