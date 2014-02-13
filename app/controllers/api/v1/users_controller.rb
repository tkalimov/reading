module Api
  module V1 
    class UsersController < ApplicationController
      after_filter :cors_set_access_control_headers      
      before_filter :authenticate_user_from_token!
      before_filter :authenticate_api_v1_user!

      def index      
        @users = User.all
        render json: @users.as_json(only: [:id, :first_name, :last_name, :email, :business_name, :created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at])
      end

      def show
        @user = User.find(params[:id])

        render json: @user.as_json(only: [:id, :first_name, :last_name, :email, :business_name, :created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at])
      end
      
      # PATCH/PUT /users/1
      # PATCH/PUT /users/1.json
      def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
          render json: @user.as_json(only: [:id, :first_name, :last_name, :email, :business_name, :created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :authentication_token])
          sign_in @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # DELETE /users/1
      # DELETE /users/1.json
      def destroy
        @user = User.find(params[:id])
        if @user.destroy
          render :json=>{:success=>true, :message=>"User deleted"}
        end 
      end

      private 
      
      def user_params
          params.require(:user).permit(:first_name, :last_name, :email, :password, :business_name, :avatar)
      end 
      
      def authenticate_user_from_token!
  	    # user_token = params[:user_token].presence
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

  # def show
  #   @post = Post.find(params[:id])
  # #   render json: @post.as_json(
  #     only: [:id, :content, :created_at],
  #     include: { user: { only: [:id, :username] } }
  #   )
  # end