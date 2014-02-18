class User < ActiveRecord::Base
  has_many :conversations, dependent: :destroy 
  has_surveys
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:twitter]
  has_attached_file :avatar, styles: {thumb: '100x100>', square: '200x200#', medium: '300x300>'}
  before_save :ensure_authentication_token
 
  

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

#OMNIAUTH METHODS 
  def self.find_for_twitter_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name 
      user.last_name = auth.info.last_name
      # user.avatar = auth.info.image # assuming the user model has an image
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
