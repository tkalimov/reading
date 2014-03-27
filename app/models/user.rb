class User < ActiveRecord::Base
  has_many :conversations, dependent: :destroy 
  has_many :videos, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_attached_file :avatar, styles: {thumb: '100x100>', square: '200x200#', medium: '300x300>'}
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:linkedin, :google_oauth2, :facebook, :khan_academy]
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

  def video_summary
    output = {last_week: {total:0}, last_month: {total:0}, last_half_year: {total: 0}, last_year: {total: 0}}
    self.videos.each do |video|
      if video.time_watched > 1.week.ago.utc
        if output[:last_week][video.category] != nil
          output[:last_week][video.category][:videos_watched] += 1
          output[:last_week][video.category][:seconds_watched] += video.length
        else
          output[:last_week][video.category] = {videos_watched: 1, seconds_watched: video.length}
        end
        output[:last_week][:total] += 1
      end

      if video.time_watched > 1.month.ago.utc
        if output[:last_month][video.category] != nil
          output[:last_month][video.category][:videos_watched] += 1
          output[:last_month][video.category][:seconds_watched] += video.length
        else
          output[:last_month][video.category] = {videos_watched: 1, seconds_watched: video.length}
        end
        output[:last_month][:total] += 1
      end

      if video.time_watched > 6.months.ago.utc
        if output[:last_half_year][video.category] != nil
          output[:last_half_year][video.category][:videos_watched] += 1
          output[:last_half_year][video.category][:seconds_watched] += video.length
        else
          output[:last_half_year][video.category] = {videos_watched: 1, seconds_watched: video.length}
        end
        output[:last_half_year][:total] += 1
      end

      if video.time_watched > 1.year.ago.utc
        if output[:last_year][video.category] != nil
          output[:last_year][video.category][:videos_watched] += 1
          output[:last_year][video.category][:seconds_watched] += video.length
        else
          output[:last_year][video.category] = {videos_watched: 1, seconds_watched: video.length}
        end
        output[:last_year][:total] += 1
      end
    end 
    return output
  end 

  def article_summary
    output = Hash.new()
    user = User.first
      user.articles.each do |item|
        if item.time_read > 1.week.ago.utc
          words_last_week +=  item.word_count
        elsif item.time_read > 1.month.ago.utc
          words_last_month += item.word_count
        elsif item.time_read > 1.year.ago.utc
          words_last_year += item.word_count
        end 
      end
      output = {words_last_week: words_last_week, words_last_month: words_last_month, words_last_year: words_last_year} 
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
