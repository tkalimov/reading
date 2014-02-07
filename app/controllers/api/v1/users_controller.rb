module Api
  module V1 
    class UsersController < ApplicationController
      after_filter :cors_set_access_control_headers
      before_filter :authenticate_user_from_token!
      before_filter :authenticate_api_v1_user!

      def index
        @users = User.all
        render json: @users
      end

      def show
        @user = User.find(params[:id])

        render json: @user
      end

      private 
      
      def user_params
          params.require(:user).permit(:name, :email, :password)
      end 

      def authenticate_user_from_token!
	    user_token = params[:user_token].presence
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
  #   render json: @post.as_json(
  #     only: [:id, :content, :created_at],
  #     include: { user: { only: [:id, :username] } }
  #   )
  # end