module Api
	module V1
		class RegistrationsController < Devise::RegistrationsController
			
		      after_filter :cors_set_access_control_headers

		      def create
		        @user = User.new(user_params)

		        if @user.save
		          # render json: @user, status: :created
		          render :json=> {:success=>true, :auth_token=>@user.authentication_token, :email=>@user.email}
		        else
		          render json: @user.errors, status: :unprocessable_entity
		        end
		      end

		      # PATCH/PUT /users/1
		      # PATCH/PUT /users/1.json
		      def update
		        @user = User.find(params[:id])

		        if @user.update(params[:user])
		          head :no_content
		        else
		          render json: @user.errors, status: :unprocessable_entity
		        end
		      end

		      # DELETE /users/1
		      # DELETE /users/1.json
		      def destroy
		        @user = User.find(params[:id])
		        @user.destroy

		        head :no_content
		      end
				
		    
		      private 
		      
		      def user_params
		          params.require(:user).permit(:first_name, :last_name, :email, :password, :business_name)
		      end 

		end 
	end
end 
