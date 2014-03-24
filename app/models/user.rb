class User < ActiveRecord::Base
  has_many :conversations, dependent: :destroy 
  has_attached_file :avatar, styles: {thumb: '100x100>', square: '200x200#', medium: '300x300>'}
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:linkedin, :google_oauth2, :facebook]
  before_save :ensure_authentication_token
  validates :first_name, presence: true
  validates :last_name, presence: true
  before_save { |user| user.first_name = first_name.downcase.capitalize }
  before_save { |user| user.last_name = last_name.downcase.capitalize }
  
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def self.find_for_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name 
      user.last_name = auth.info.last_name
      user.avatar = URI.parse(auth.info.image) if auth.info.image?      
    end
  end

  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
