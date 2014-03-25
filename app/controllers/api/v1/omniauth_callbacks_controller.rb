module Api
  module V1
		class OmniauthCallbacksController < Devise::OmniauthCallbacksController
			def all
			    @user = User.find_for_oauth(request.env["omniauth.auth"]) 
				$google_access_token = request.env["omniauth.auth"].credentials['token']
			    if @user.persisted?
			      sign_in @user, :event => :authentication #this will throw if @user is not activated
			      render :json=> {:success=>true, :auth_token=>@user.authentication_token, :email=>@user.email}
			    else
			      render :json=> {:success=>false, :errors=>@user.errors}
			  	end 
		    end

		    alias_method :linkedin, :all
			alias_method :google_oauth2, :all
			alias_method :facebook, :all
			alias_method :khan_academy, :all
		end
	end 
end 