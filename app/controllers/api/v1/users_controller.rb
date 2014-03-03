module Api
  module V1 
    class UsersController < ApplicationController
      after_filter :cors_set_access_control_headers      
      before_filter :authenticate_user_from_token!#, :except => [:find_business ]
      before_filter :authenticate_api_v1_user! #, :except => [:find_business, :user_params ]

      def index      
        @users = User.all
        render json: @users.as_json(only: [:id, :first_name, :last_name, :email, :business_name, :created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at])
      end

      def show
        @user = User.find(params[:id])
        render json: @user.as_json(only: [:id, :first_name, :last_name, :email, :business_name, :created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at])
      end
      
      def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
          render json: @user.as_json(only: [:id, :first_name, :last_name, :email, :business_name, :created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :authentication_token])
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

      def find_business
        current_api_v1_user.update_attributes(user_params)
        zipCode = current_api_v1_user.business_zipcode
        apiKey = "AIzaSyCs09hsOJdkcaY5srhstDee1V09s-pYnl4" 
        apiKey2 = 10000005659 
        businessName = current_api_v1_user.business_name
        geocodeURL = "https://maps.googleapis.com/maps/api/geocode/json?"
        geocodeResponse = HTTParty.get(geocodeURL, {query: {address: zipCode, sensor: 'false', key: apiKey}})
        latitude = geocodeResponse['results'][0]['geometry']['location']['lat']
        longitude = geocodeResponse['results'][0]['geometry']['location']['lng']
        coordinates = latitude.to_s + ',' + longitude.to_s
          
          placesURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
        placesResponse = HTTParty.get(placesURL, {query: {location: coordinates, radius: '10000', sensor: 'false', query: businessName, key: apiKey}})
        render json: placesResponse
      end
      
      def create_business
        @user = current_api_v1_user
        if @user.update_attributes(user_params)
          render json: @user.as_json(only: [:id, :first_name, :last_name, :email, :business_name, :business_address, :business_zipcode, :created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :authentication_token])
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private 
      
      def user_params
          params.require(:user).permit(:first_name, :last_name, :email, :password, :business_name, :avatar, :business_zipcode, :business_address)
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