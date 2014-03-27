module ApiHelper
	def update_pocket
        user = User.first
        pocketAPI = 'https://getpocket.com/v3/get'
        time_pocket_called = Time.now
        if user.pocket_since 
          since = user.pocket_since.to_time.to_i
        else 
          since = 0
        end 
        pocketReadArticles = HTTParty.post(pocketAPI, :body => {consumer_key: ENV['POCKET_CONSUMER_KEY'], access_token: user.pocket_access_token, state: 'archive', contentType: 'article', sort: 'newest', detailType: 'complete', since: since})
    
        if pocketReadArticles['list'].length > 0 
          pocketReadArticles['list'].values.each do |item|
            if item['tags']
              categories = item['tags'].keys
            else 
              categories = nil
            end 
            user.articles.create!(title: item['resolved_title'], url: item['resolved_url'], word_count: item['word_count'].to_i, time_added: Time.at(item['time_added'].to_i), time_read: Time.at(item['time_read'].to_i), categories: categories)
          end 
        end 
        user.update_attributes(pocket_since: time_pocket_called, pocket_connected: true)
    end 

    def update_youtube
        index = 1
        user = User.first 
        catch (:done) do 
            while index < 10000 do
              historyFeed = HTTParty.get('https://gdata.youtube.com/feeds/api/users/default/watch_history', {query: {v: 2, alt: 'json', access_token: user.google_access_token, 'max-results' => 50, 'start-index' => index}})
              if historyFeed['feed']['entry']
                historyFeed['feed']['entry'].each do |entry|
                  if user.youtube_connected == true
                    throw :done if user.videos.where(:time_watched => entry['published']['$t'], :source => 'YouTube').length > 0
                  end   

                  # videos that have been suspended no longer show duration or category so need to be accounted for
                  if entry['media$group']['yt$duration']  
                    begin
                      user.videos.create!(title: entry['title']['$t'], time_watched: entry['published']['$t'], category: entry['category'][0]['label'], length: entry['media$group']['yt$duration']['seconds'].to_i, publisher: entry['media$group']['media$credit'][0]['yt$display'], source_video_id: entry['media$group']['yt$videoid']['$t'], source: 'YouTube')
                    rescue 
                    end 
                  else
                    begin  
                      user.videos.create!(title: entry['title']['$t'], time_watched: entry['published']['$t'], category: 'uncategorized', length: 0, publisher: entry['media$group']['media$credit'][0]['yt$display'], source_video_id: entry['media$group']['yt$videoid']['$t'], source: 'YouTube')
                    rescue 
                    end 
                  end 
                end
                index += 50
              else
                user.update_attribute(:youtube_connected, true) 
                throw :done 
              end 
            end 
        end 
    end

    def update_khan
		user = User.first 

		user_info = khan_stats('')
		videos = khan_stats('/videos')				
		# exercises = khan_stats('/exercises')

		catch (:done) do
			videos.each do |video|
				if user.khan_connected == true
					throw :done if user.videos.where(:time_watched => video['last_watched'], source: 'Khan Academy').length > 0
				end 
				user.videos.create!(title: video['video']['title'], time_watched: video['last_watched'], length: video['duration'], seconds_watched: video['seconds_watched'], source_video_id: video['video']['youtube_id'], publisher: video['video']['author_names'], source: 'Khan Academy')	
			end 
			user.update_attribute(:khan_connected, true) if user.videos.find_by(source: "Khan Academy")
			throw :done
		end 										    		
	end

	def khan_stats(type)
		user = User.first 
		oauth_nonce = SecureRandom.hex
		oauth_timestamp = Time.now.to_i
		url = "https://www.khanacademy.org/api/v1/user#{type}"
		encoded_url = CGI::escape(url)
		param_string = CGI::escape("oauth_consumer_key=#{ENV['KHAN_CONSUMER_KEY']}&oauth_nonce=#{oauth_nonce}&oauth_signature_method=HMAC-SHA1&oauth_timestamp=#{oauth_timestamp}&oauth_token=#{user.khan_access_token}&oauth_version=1.0")
		signature_string = "GET&#{encoded_url}&" + param_string
		key = CGI::escape(ENV['KHAN_CONSUMER_SECRET']) + '&' + CGI::escape(user.khan_secret_token) 

		#BUG 
		#Encoding is generating a \n at the end of the signature that shouldn't be there so I manually subtract it here: 	
		oauth_signature = Base64.encode64("#{OpenSSL::HMAC.digest('sha1',key, signature_string)}")[0..-2]
		auth_header = "OAuth oauth_consumer_key=\"#{CGI::escape(ENV['KHAN_CONSUMER_KEY'])}\", oauth_nonce=\"#{CGI::escape(oauth_nonce)}\", oauth_signature=\"#{CGI::escape(oauth_signature)}\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"#{oauth_timestamp}\", oauth_token=\"#{CGI::escape(user.khan_access_token)}\", oauth_version=\"1.0\""

		output = HTTParty.get(url, :headers => {'Authorization' => auth_header})
	end 
end