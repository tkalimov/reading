module Api
  module V1
      class ConversationsController < ApplicationController
      after_filter :cors_set_access_control_headers
      before_filter :authenticate_user_from_token!
      before_filter :authenticate_api_v1_user!
      before_action :correct_user,   only: :destroy

      def index
        @conversations = Conversation.all
        render json: @conversations.as_json(only: [:id, :content, :created_at], 
            include: { user: { only: [:id, :first_name, :last_name, :business_name] } })
      end

      def create
        @conversation = current_api_v1_user.conversations.build(conversation_params)

        if @conversation.save
          render json: @conversation, status: :created
        else
          render json: @conversation.errors, status: :unprocessable_entity
        end 
      end

      def destroy
        @conversation = Conversation.find(params[:id])
        if @conversation.destroy
          render :json=>{:success=>true, :message=>"Post deleted"}
        else 
          render :json=>{:success=>false, :message=>"This was not your post and you cannot delete it"}
        end 
      end

      private

        def conversation_params
          params.require(:conversation).permit(:content)
        end

        def authenticate_user_from_token!
        user_token = request.headers['user-token']
        user       = user_token && User.find_by_authentication_token(user_token.to_s)
     
        if user
          # Notice we are passing store false, so the user is not
          # actually stored in the session and a token is needed
          # for every request. If you want the token to work as a
          # sign in token, you can simply remove store: false.
          sign_in user
        end
      end
        
        def correct_user
          @conversation = current_api_v1_user.conversations.find_by(id: params[:id])
        end
    end
  end 
end