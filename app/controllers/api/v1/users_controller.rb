module Api
  module V1 
    class UsersController < ApplicationController
      after_filter :cors_set_access_control_headers
      before_filter :authenticate_user!

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