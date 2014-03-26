module Api
	module V1 
		class StatsController < ApplicationController
			def pocket_auth
		        pocketURL = 'https://getpocket.com/v3/oauth/request'
		        $pocket_start = HTTParty.post(pocketURL, :body => {consumer_key: ENV['POCKET_CONSUMER_KEY'], redirect_uri: "http://localhost:3000/api/v1/stats/pocket_middle"}, :headers => {'X-Accept' => 'application/json'})
		        url = 'https://getpocket.com/auth/authorize?request_token=' + $pocket_start.parsed_response["code"] + '&redirect_uri=http://localhost:3000/api/v1/stats/pocket_middle'
		        redirect_to url
	      	end 

	      	def pocket_middle
	        	authorizeURL = 'https://getpocket.com/v3/oauth/authorize' 
	         	user_response = HTTParty.post(authorizeURL, :body => {consumer_key: ENV['POCKET_CONSUMER_KEY'], code: $pocket_start.parsed_response["code"]}, :headers => {'X-Accept' => 'application/json'})
	            $user_access_token = user_response.parsed_response['access_token']
	      	end 
	      
	      	def pocket_list
		        pocketAPI = 'https://getpocket.com/v3/get'
		        pocketList = HTTParty.post(pocketAPI, :body => {consumer_key: ENV['POCKET_CONSUMER_KEY'], access_token: $user_access_token, state: 'all'})
		        words_last_week = 0
		        words_last_month = 0
		        words_last_year = 0 

		        pocketList['list'].values.each do |item|
		          if Time.at(item['time_read'].to_i) > 1.week.ago.utc
		            words_last_week +=  item['word_count'].to_i
		          elsif Time.at(item['time_read'].to_i) > 1.month.ago.utc
		            words_last_month += item['word_count'].to_i
		          elsif Time.at(item['time_read'].to_i) > 1.year.ago.utc
		            words_last_year += item['word_count'].to_i
		          end 
		        end 
	        	
	        	render :json => {:last_week=>words_last_week, :last_month=>words_last_month, :last_year =>words_last_year}
	      	end 
		
			def youtube
				# Code for YouTube V2 API
				index = 1
				i = 0
				user = User.first 
				catch (:done) do 
					while index < 10000 do
    					historyFeed = HTTParty.get('https://gdata.youtube.com/feeds/api/users/default/watch_history', {query: {v: 2, alt: 'json', access_token: $access_token, 'max-results' => 50, 'start-index' => index}})

						if historyFeed['feed']['entry']
							if user.videos.first
								#checking to see if the feed has changed since last time it was pulled 
								#First video doesn't work and needs to be fixed -- lookup first video in feed in database with that same watched time 
								throw :done if user.videos.first.watched == historyFeed['feed']['entry'][0]['published']['$t']
							end 
							
			    			historyFeed.parsed_response['feed']['entry'].each do |entry|
			    				if entry['media$group']['yt$duration']  # videos that have been suspended no longer show duration or category so need to be accounted for 
			    					begin
			    						user.videos.create!(title: entry['title']['$t'], watched: entry['published']['$t'], category: entry['category'][0]['label'], length: entry['media$group']['yt$duration']['seconds'].to_i, publisher: entry['media$group']['media$credit'][0]['yt$display'], source_video_id: entry['media$group']['yt$videoid']['$t'], source: 'YouTube')
			    					rescue 
			    					end 
			    				else
			    					begin  
			    						user.videos.create!(title: entry['title']['$t'], watched: entry['published']['$t'], category: 'uncategorized', length: 0, publisher: entry['media$group']['media$credit'][0]['yt$display'], source_video_id: entry['media$group']['yt$videoid']['$t'], source: 'YouTube')
			    					rescue 
			    					end 
			    				end 
			    			end
			    			index += 50
			    		else 
			    			throw :done 
			    		end 
				    end 
	    		end 
	    		render :json => {:total_watched => user.videos.length, :stats => user.video_stats }

	    		# Code for YouTube V3 API
					# channelsURL = 'https://www.googleapis.com/youtube/v3/channels'
					# ytChannels = HTTParty.get(channelsURL, {query: {part: 'contentDetails', mine: 'true', access_token: $google_access_token}})
					# watchHistoryID = ytChannels.parsed_response['items'][0]['contentDetails']['relatedPlaylists']['watchHistory'] 
					# playlistURL = 'https://www.googleapis.com/youtube/v3/playlistItems'
					# watchList = HTTParty.get(playlistURL, {query: {part: 'snippet', playlistId: watchHistoryID, maxResults: 50, access_token: $google_access_token}})	
					# debugger
					# render :json => {:test => watchList}
					
					#THINGS TO EXPLORE 
					#Category ID for each video 
					#{}"contentDetails": {
	    			#	"duration": "PT13M33S",
			end
			

			def khan_auth
				def khan_stats(type)
					oauth_nonce = SecureRandom.hex
					oauth_timestamp = Time.now.to_i
					url = "https://www.khanacademy.org/api/v1/user#{type}"
					encoded_url = CGI::escape(url)
					param_string = CGI::escape("oauth_consumer_key=#{ENV['KHAN_CONSUMER_KEY']}&oauth_nonce=#{oauth_nonce}&oauth_signature_method=HMAC-SHA1&oauth_timestamp=#{oauth_timestamp}&oauth_token=#{$access_token}&oauth_version=1.0")
					signature_string = "GET&#{encoded_url}&" + param_string
					key = CGI::escape(ENV['KHAN_CONSUMER_SECRET']) + '&' + CGI::escape($secret_token) 

					#BUG 
					#Encoding is generating a \n at the end of the signature that shouldn't be there so I manually subtract it here: 	
					oauth_signature = Base64.encode64("#{OpenSSL::HMAC.digest('sha1',key, signature_string)}")[0..-2]
					auth_header = "OAuth oauth_consumer_key=\"#{CGI::escape(ENV['KHAN_CONSUMER_KEY'])}\", oauth_nonce=\"#{CGI::escape(oauth_nonce)}\", oauth_signature=\"#{CGI::escape(oauth_signature)}\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"#{oauth_timestamp}\", oauth_token=\"#{CGI::escape($access_token)}\", oauth_version=\"1.0\""

					output = HTTParty.get(url, :headers => {'Authorization' => auth_header})
				end 
				user_info = khan_stats('')
				videos = khan_stats('/videos')

				debugger
				# exercises = khan_stats('/exercises')
				

				user = User.first 
				catch (:done) do 
					#change migration to be last_watched, add seconds_watcehd

					videos.each do |video|
						if user.videos.first
							#checking to see if the feed has changed since last time it was pulled 
							#First video doesn't work and needs to be fixed -- lookup first video in feed in database with that same watched time 
							throw :done if user.videos.first.watched == videos[0]['last_watched']
						end 
						
						user.videos.create!(title: video['video']['title'], time_watched: video['last_watched'], category: video['video']['keywords'], length: video['duration'], seconds_watched: video['seconds_watched'], source_video_id: video['video']['youtube_id'], source: 'Khan Academy')	
					end 							
	    				throw :done 
			    		
	    		end 
				
				render :json => {:videos=>videos, :user_info=>user_info}
			end 
		end
	end
end