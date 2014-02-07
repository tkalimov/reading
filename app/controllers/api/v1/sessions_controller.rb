module Api
  module V1
      class SessionsController < Devise::SessionsController
	    # prepend_before_filter :require_no_authentication, :only => [:create ]
	    before_filter :ensure_params_exist
	    
	    def create
	      # build_resource
	      resource = User.find_for_database_authentication(:email => params[:user][:email])
	      return invalid_login_attempt unless resource

	      if resource.valid_password?(params[:user][:password])
	        sign_in("user", resource)
	        render :json=> {:success=>true, :auth_token=>resource.authentication_token, :email=>resource.email}
	      return
	      end
	      invalid_login_attempt
	    end

	    def destroy
	      sign_out(resource_name)
	    end
		
		# def build_resource(hash=nil)
  #   		self.resource = resource_class.new_with_session(hash || {}, session)
  # 		end
	    
	    protected

	    def ensure_params_exist
	      return unless params[:user][:email].blank?
	      render :json=>{:success=>false, :message=>"missing login email parameter"}, :status=>422
	    end

	    def invalid_login_attempt
	      warden.custom_failure!
	      render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
	    end

	  end
  end
end