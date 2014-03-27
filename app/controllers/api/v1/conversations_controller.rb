module Api
  module V1
      class ConversationsController < ApplicationController
      after_filter :cors_set_access_control_headers
      before_filter :authenticate_user_from_token!
      before_filter :authenticate_api_v1_user!
      before_action :correct_user,   only: :destroy

      def index
        conversations = Conversation.all
        render json: conversations.as_json(only: [:id, :content, :created_at, :category], 
            include: { user: { only: [:id, :first_name, :last_name] } })
      end
      
      def notebook
        notebook = Conversation.where(:user_id => current_api_v1_user, :category=> "Personal")
        notebook.sort_by(&:created_at)
        render json: notebook
      end 

      def create
        conversation = current_api_v1_user.conversations.build(conversation_params)
        if conversation.save
          render json: conversation, status: :created
        else
          render json: conversation.errors, status: :unprocessable_entity
        end 
      end

      def destroy
        conversation = Conversation.find(params[:id])
        render :json=>{:success=>true, :message=>"Post deleted"} if conversation.destroy
      end

      private

        def conversation_params
          params.require(:conversation).permit(:content, :category)
        end

        def authenticate_user_from_token!
        user_token = request.headers['user-token']
        user       = user_token && User.find_by_authentication_token(user_token.to_s)
     
        if user
          sign_in user
        end
      end
        
        def correct_user
          conversation = current_api_v1_user.conversations.find_by(id: params[:id])
          # conversation = Conversation.find(params[:id])
          render json: {:success=>false, :errors=>:unauthorized_entity} if conversation.nil?
        end
    end
  end 
end