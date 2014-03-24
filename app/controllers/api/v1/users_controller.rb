module Api
  module V1 
    class UsersController < ApplicationController
      after_filter :cors_set_access_control_headers      
      # before_filter :authenticate_user_from_token!
      # before_filter :authenticate_api_v1_user! å

      def index      
        #Show all users 
        @users = User.all
        render json: @users.as_json(only: [:id, :first_name, :last_name, :email, :created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at])
      end

      def show
        #Show single user
        @user = User.find(params[:id])
        render json: @users.as_json(only: [:id, :first_name, :last_name, :email, :created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at])
      end
      
      def update
        #Update single user
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
          render json: @user.as_json(only: [:id, :first_name, :last_name, :email, :created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :authentication_token])
          sign_in @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @user = User.find(params[:id])
        if @user.destroy
          render :json=>{:success=>true, :message=>"User deleted"}
        end 
      end


      def pocket_start
        pocketURL = 'https://getpocket.com/v3/oauth/request'
        $pocket_start = HTTParty.post(pocketURL, :body => {consumer_key: "25394-e72c8667a8a092220ef3ea2e", redirect_uri: "http://localhost:3000/api/v1/pocket/pocket_middle"}, :headers => {'X-Accept' => 'application/json'})
        url = 'https://getpocket.com/auth/authorize?request_token=' + $pocket_start.parsed_response["code"] + '&redirect_uri=http://localhost:3000/api/v1/pocket/pocket_middle'
        redirect_to url
      end 

      def pocket_middle
          authorizeURL = 'https://getpocket.com/v3/oauth/authorize' 
          user_response = HTTParty.post(authorizeURL, :body => {consumer_key: "25394-e72c8667a8a092220ef3ea2e", code: $pocket_start.parsed_response["code"]}, :headers => {'X-Accept' => 'application/json'})
            $user_access_token = user_response.parsed_response['access_token']
          
      end 
      
      def pocket_list
        pocketAPI = 'https://getpocket.com/v3/get'
        pocketList = HTTParty.post(pocketAPI, :body => {consumer_key: "25394-e72c8667a8a092220ef3ea2e", access_token: "e7130a52-3403-fa56-cf2a-6cb2ec", state: 'all'})
        archived_words = 0
        unread_words = 0 
        total_words = 0
        pocketList['list'].values.each do |item|
          if item['time_read'].to_i > 0
            archived_words +=  item['word_count'].to_i
          else 
            unread_words += item['word_count'].to_i
          end 
          total_words += item['word_count'].to_i 
        end 

         render :json => {:archived=>archived_words, :unread=>unread_words, :total =>total_words}
      end 

      private 
      
      def user_params
          params.require(:user).permit(:first_name, :last_name, :email, :password)
      end 
      
      def authenticate_user_from_token!
        user_token = request.headers['user-token']
  	    user       = user_token && User.find_by_authentication_token(user_token.to_s)
  	 
  	    if user
  	      # Notice we are passing store false, so the user is not
  	      # actually stored in the session and a token is needed
  	      # for every request. If you want the token to work as a
  	      # sign in token, you can simply remove store: false.
  	      sign_in user, store: false
  	    end
	    end
    end
  end 
end