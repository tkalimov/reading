module Api
  module V1
		class OmniauthCallbacksController < Devise::OmniauthCallbacksController
			include ApiHelper
			def google_oauth2
			    # user = User.find_for_oauth(request.env["omniauth.auth"])
			    @user = current_api_v1_user
			    @user.update_attributes(:google_access_token => request.env["omniauth.auth"].credentials['token'])
				redirect_to '/#/home'
			   #  if user.persisted?
			   #    sign_in user, :event => :authentication #this will throw if user is not activated
			   #    render :json=> {:success=>true, :auth_token=>user.authentication_token, :email=>user.email}
			   #  else
			   #    render :json=> {:success=>false, :errors=>user.errors}
			  	# end 
		    end

		    def khan_academy
			    @user = User.find_by_email(request.env["omniauth.auth"]['info']['email'])
				
			    @user.update_attributes(:khan_access_token => request.env["omniauth.auth"].credentials['token'], :khan_secret_token => request.env["omniauth.auth"].credentials['secret'])
			    debugger
			    if @user.save
			      render :json=> {:success=>true, :auth_token=>@user.authentication_token, :email=>@user.email}
			    else
			      render :json=> {:success=>false, :errors=>@user.errors}
			  	end 
		    end

		    def linkedin
			    @user = User.find_for_oauth(request.env["omniauth.auth"])
				@user.linkedin_access_token = request.env["omniauth.auth"].credentials['token']

			    if @user.persisted?
			      sign_in @user, :event => :authentication #this will throw if user is not activated
			      render :json=> {:success=>true, :auth_token=>@user.authentication_token, :email=>@user.email}
			    else
			      render :json=> {:success=>false, :errors=>@user.errors}
			  	end 
		    end

		    def facebook
			    @user = User.find_for_oauth(request.env["omniauth.auth"])
				@user.facebook_access_token = request.env["omniauth.auth"].credentials['token']

			    if @user.persisted?
			      sign_in @user, :event => :authentication #this will throw if user is not activated
			      render :json=> {:success=>true, :auth_token=>@user.authentication_token, :email=>@user.email}
			    else
			      render :json=> {:success=>false, :errors=>@user.errors}
			  	end 
		    end

		end
	end 
end 