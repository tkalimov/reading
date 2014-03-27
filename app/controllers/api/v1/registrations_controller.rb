module Api
	module V1
		class RegistrationsController < Devise::RegistrationsController
		      after_filter :cors_set_access_control_headers

		      def create
		        user = User.new(user_params)

		        if user.save
		          render :json=> {:success=>true, :auth_token=>user.authentication_token, :email=>user.email}
		          sign_in user
		        else
		          render json: user.errors, status: :unprocessable_entity
		        end
		      end
		      
		      private 
		      
		      def user_params
		          params.require(:user).permit(:first_name, :last_name, :email, :password, :business_name, :avatar)
		      end 

		end 
	end
end 
