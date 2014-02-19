module Api
  module V1
		class OmniauthCallbacksController < Devise::OmniauthCallbacksController
			def twitter
			    # You need to implement the method below in your model (e.g. app/models/user.rb)
			    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"])

			    if @user.persisted?
			      sign_in @user, :event => :authentication #this will throw if @user is not activated
			      render :json=> {:success=>true, :auth_token=>@user.authentication_token, :email=>@user.email}
			    else
			      render :json=> {:success=>false, :errors=>@user.errors}
			  	end 
		    end

			def linkedin
			    # You need to implement the method below in your model (e.g. app/models/user.rb)
			    @user = User.find_for_linkedin_oauth(request.env["omniauth.auth"])

			    if @user.persisted?
			      sign_in @user, :event => :authentication #this will throw if @user is not activated
			      render :json=> {:success=>true, :auth_token=>@user.authentication_token, :email=>@user.email}
			    else
			      render :json=> {:success=>false, :errors=>@user.errors}
			  	end 
		    end

		    def google_oauth2
			    # You need to implement the method below in your model (e.g. app/models/user.rb)
			    @user = User.find_for_google_oauth(request.env["omniauth.auth"])

			    if @user.persisted?
			      sign_in @user, :event => :authentication #this will throw if @user is not activated
			      render :json=> {:success=>true, :auth_token=>@user.authentication_token, :email=>@user.email}
			    else
			      render :json=> {:success=>false, :errors=>@user.errors}
			  	end 
		    end			    
		end
	end 
end 