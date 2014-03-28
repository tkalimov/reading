class User < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
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
    output = {last_week: {total: {videos_watched: 0, seconds_watched: 0}}, last_month: {total: {videos_watched: 0, seconds_watched: 0}}, last_6_months: {total: {videos_watched: 0, seconds_watched: 0}}, last_year: {total: {videos_watched: 0, seconds_watched: 0}}}
    
    self.videos.each do |video|
      if video.time_watched > 1.week.ago.utc
        if output[:last_week][video.category] != nil
          output[:last_week][video.category][:videos_watched] += 1
          output[:last_week][video.category][:seconds_watched] += video.length
        else
          output[:last_week][video.category] = {videos_watched: 1, seconds_watched: video.length}
        end
        output[:last_week][:total][:videos_watched] += 1
        output[:last_week][:total][:seconds_watched] += video.length
      end

      if video.time_watched > 1.month.ago.utc
        if output[:last_month][video.category] != nil
          output[:last_month][video.category][:videos_watched] += 1
          output[:last_month][video.category][:seconds_watched] += video.length
        else
          output[:last_month][video.category] = {videos_watched: 1, seconds_watched: video.length}
        end
        output[:last_month][:total][:videos_watched] += 1
        output[:last_month][:total][:seconds_watched] += video.length
      end

      if video.time_watched > 6.months.ago.utc
        if output[:last_6_months][video.category] != nil
          output[:last_6_months][video.category][:videos_watched] += 1
          output[:last_6_months][video.category][:seconds_watched] += video.length
        else
          output[:last_6_months][video.category] = {videos_watched: 1, seconds_watched: video.length}
        end
        output[:last_6_months][:total][:videos_watched] += 1
        output[:last_6_months][:total][:seconds_watched] += video.length
      end

      if video.time_watched > 1.year.ago.utc
        if output[:last_year][video.category] != nil
          output[:last_year][video.category][:videos_watched] += 1
          output[:last_year][video.category][:seconds_watched] += video.length
        else
          output[:last_year][video.category] = {videos_watched: 1, seconds_watched: video.length}
        end
        output[:last_year][:total][:videos_watched] += 1
        output[:last_year][:total][:seconds_watched] += video.length
      end
    end 

    return output
  end 


  def article_summary
    output = {labels: [], data:[]}
    weeks = 8
    
    list = self.articles.where("time_read > :start_date", {start_date: weeks.week.ago.utc})
    list.each do |article|
      index = 0  
      while index < weeks do
        if article.time_read > (index+1).week.ago.utc && article.time_read < index.week.ago.utc 
            if output[:data][index]
              output[:data][index] += article.word_count
            else 
              output[:data][index] = (article.word_count)
            end 
        end
        index += 1
      end
    end 
    i = 1
    output[:labels].push('Last week')
    while i < output[:data].length do 
        output[:labels].push("#{pluralize(i, 'week')} ago")
        i += 1
    end 
    return output
  end 

  # def old_article_summary
  #   output = {last_week: {articles_read:0, words_read: 0, seconds_read:0}, last_month: {articles_read:0, words_read: 0, seconds_read:0}, last_6_months: {articles_read:0, words_read: 0, seconds_read:0}, last_year: {articles_read:0, words_read: 0, seconds_read:0}}
  #   avg_wpm = 300 #words per minute 
  #   words_per_second = avg_wpm / 60

  #   self.articles.each do |article|
  #     if article.time_read > 1.week.ago.utc
  #       output[:last_week][:articles_read] += 1
  #       output[:last_week][:words_read] += article.word_count
  #       output[:last_week][:seconds_read] += article.word_count / words_per_second
  #     end
      
  #     if article.time_read > 1.month.ago.utc
  #       output[:last_month][:articles_read] += 1
  #       output[:last_month][:words_read] += article.word_count
  #       output[:last_month][:seconds_read] += article.word_count / words_per_second
  #     end
      
  #     if article.time_read > 6.months.ago.utc
  #       output[:last_6_months][:articles_read] += 1
  #       output[:last_6_months][:words_read] += article.word_count
  #       output[:last_6_months][:seconds_read] += article.word_count / words_per_second
  #     end

  #     if article.time_read > 1.year.ago.utc
  #       output[:last_year][:articles_read] += 1
  #       output[:last_year][:words_read] += article.word_count
  #       output[:last_year][:seconds_read] += article.word_count / words_per_second
  #     end
  #   end 
  #   return output
  # end 

  def self.find_for_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name 
      user.last_name = auth.info.last_name
      # user.avatar = URI.parse(auth.info.image) if auth.info.image?      
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
