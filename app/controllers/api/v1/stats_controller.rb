module Api
	module V1 
		class StatsController < ApplicationController
			def pocket_auth
		        pocketURL = 'https://getpocket.com/v3/oauth/request'
		        $pocket_start = HTTParty.post(pocketURL, :body => {consumer_key: "25394-e72c8667a8a092220ef3ea2e", redirect_uri: "http://localhost:3000/api/v1/stats/pocket_middle"}, :headers => {'X-Accept' => 'application/json'})
		        url = 'https://getpocket.com/auth/authorize?request_token=' + $pocket_start.parsed_response["code"] + '&redirect_uri=http://localhost:3000/api/v1/stats/pocket_middle'
		        redirect_to url
	      	end 

	      	def pocket_middle
	        	authorizeURL = 'https://getpocket.com/v3/oauth/authorize' 
	         	user_response = HTTParty.post(authorizeURL, :body => {consumer_key: "25394-e72c8667a8a092220ef3ea2e", code: $pocket_start.parsed_response["code"]}, :headers => {'X-Accept' => 'application/json'})
	            $user_access_token = user_response.parsed_response['access_token']
	      	end 
	      
	      	def pocket_list
		        pocketAPI = 'https://getpocket.com/v3/get'
		        pocketList = HTTParty.post(pocketAPI, :body => {consumer_key: "25394-e72c8667a8a092220ef3ea2e", access_token: $user_access_token, state: 'all'})
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
    					historyFeed = HTTParty.get('https://gdata.youtube.com/feeds/api/users/default/watch_history', {query: {v: 2, alt: 'json', access_token: $google_access_token, 'max-results' => 50, 'start-index' => index}})

						if historyFeed['feed']['entry']
							if user.videos.first
								throw :done if user.videos.first.watched == historyFeed['feed']['entry'][0]['published']['$t']
							end 

			    			historyFeed.parsed_response['feed']['entry'].each do |entry|
			    				if entry['media$group']['yt$duration']  # videos that have been suspended no longer show duration or category so need to be accounted for 
			    					begin
			    						user.videos.create!(title: entry['title']['$t'], watched: entry['published']['$t'], category: entry['category'][0]['label'], length: entry['media$group']['yt$duration']['seconds'].to_i, publisher: entry['media$group']['media$credit'][0]['yt$display'])
			    					rescue 
			    					end 
			    				else
			    					begin  
			    						user.videos.create!(title: entry['title']['$t'], watched: entry['published']['$t'], category: 'uncategorized', length: 0, publisher: entry['media$group']['media$credit'][0]['yt$display'])
			    					rescue 
			    					end 
			    				end 
			    			end
			    			index += 50
			    		else 
			    			throw :done 
			    		end 
				    end 
			    		# change term to label
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
		end
	end
end