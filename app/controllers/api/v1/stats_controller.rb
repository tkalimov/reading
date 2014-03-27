module Api
	module V1 
		class StatsController < ApplicationController
			include ApiHelper
			#TWO METHODS TO AUTHORIZE POCKET 
			def pocket_auth
		        pocketTokenRequestURL = 'https://getpocket.com/v3/oauth/request'
		        redirect_url = "http://roundview3.herokuapp.com/api/v1/pocket_middle"
		        response = HTTParty.post(pocketTokenRequestURL, :body => {consumer_key: ENV['POCKET_CONSUMER_KEY'], redirect_uri: redirect_url}, :headers => {'X-Accept' => 'application/json'})
		        $pocket_token = response.parsed_response["code"]
		        url = 'https://getpocket.com/auth/authorize?request_token=' + $pocket_token + "&redirect_uri=#{redirect_url}"
		        redirect_to url
	      	end 

	      	def pocket_middle
	      		@user = current_api_v1_user
	        	pocketAuthorizeURL = 'https://getpocket.com/v3/oauth/authorize' 
	         	user_response = HTTParty.post(pocketAuthorizeURL, :body => {consumer_key: ENV['POCKET_CONSUMER_KEY'], code: $pocket_token}, :headers => {'X-Accept' => 'application/json'})

	            @user.update_attributes(:pocket_access_token => user_response.parsed_response['access_token'])
	            redirect_to '/#/home'
				if @user.pocket_access_token 
          			update_pocket
        		end
	      	end 
		end
	end
end