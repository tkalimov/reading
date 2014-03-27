module Api
	module V1 
		class StatsController < ApplicationController

			#TWO METHODS TO AUTHORIZE POCKET 
			def pocket_auth
		        pocketTokenRequestURL = 'https://getpocket.com/v3/oauth/request'
		        response = HTTParty.post(pocketTokenRequestURL, :body => {consumer_key: ENV['POCKET_CONSUMER_KEY'], redirect_uri: "http://localhost:3000/api/v1/pocket_middle"}, :headers => {'X-Accept' => 'application/json'})
		        $pocket_token = response.parsed_response["code"]
		        url = 'https://getpocket.com/auth/authorize?request_token=' + $pocket_token + '&redirect_uri=http://localhost:3000/api/v1/pocket_middle'
		        redirect_to url
	      	end 

	      	def pocket_middle
	      		user = User.first
	        	pocketAuthorizeURL = 'https://getpocket.com/v3/oauth/authorize' 
	         	user_response = HTTParty.post(pocketAuthorizeURL, :body => {consumer_key: ENV['POCKET_CONSUMER_KEY'], code: $pocket_start.parsed_response["code"]}, :headers => {'X-Accept' => 'application/json'})
	            user.update_attributes(:pocket_access_token => user_response.parsed_response['access_token'])
	            redirect_to root_path
	      	end 
		end
	end
end