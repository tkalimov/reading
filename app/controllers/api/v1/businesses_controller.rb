module Api
  module V1 
		class BusinessesController < ApplicationController
		  after_filter :cors_set_access_control_headers

		  def find
			@business = Business.new(business_params)
			zipCode = @business.zipcode
		    apiKey = "AIzaSyCs09hsOJdkcaY5srhstDee1V09s-pYnl4" 
		    apiKey2 = 10000005659 
		    businessName = @business.name
		    geocodeURL = "https://maps.googleapis.com/maps/api/geocode/json?"
		    geocodeResponse = HTTParty.get(geocodeURL, {query: {address: zipCode, sensor: 'false', key: apiKey}})
			latitude = geocodeResponse['results'][0]['geometry']['location']['lat']
			longitude = geocodeResponse['results'][0]['geometry']['location']['lng']
			coordinates = latitude.to_s + ',' + longitude.to_s
		    
		    placesURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
			placesResponse = HTTParty.get(placesURL, {query: {location: coordinates, radius: '10000', sensor: 'false', query: businessName, key: apiKey}})
			render json: placesResponse
		  end
			
		  def create 
		  	@business = Business.new(business_params)
		        if @business.save
		          render :json=> {:success=>true, :auth_token=>@user.authentication_token, :email=>@user.email}
		          sign_in @user
		        else
		          render json: @user.errors, status: :unprocessable_entity
		        end
		  end 
			private 
			  def business_params
			      params.require(:business).permit(:name, :street_address, :city, :state, :zipcode, :phone)
			  end 
		end
	end 
end 	