module Api
	module V1
		class SurveysController < ApplicationController
			after_filter :cors_set_access_control_headers
			before_filter :authenticate_user_from_token!
      		before_filter :authenticate_api_v1_user!

			def index 
				@surveys = Survey.all
				render json: @surveys
			end
			
			def create 
				@survey = Survey.new(survey_params)
				if @survey.save
					render json: @survey, status: :created
				else 
					render json: @survey.errors, status: :unprocessable_entity
				end 
			end

			def show
		    	@survey = Survey.find(params[:id])
		    	render json: @survey
		  	end

		    def update
		    	@survey = Survey.find(params[:id])
		    	 
		    	if @survey.update(params[:survey])
          			head :no_content
        		else
          			render json: @survey.errors, status: :unprocessable_entity
        		end
		    end

		    def destroy
		        @survey = Survey.find(params[:id])
        		@survey.destroy
        		head :no_content
		    end

		  	private

		    def survey_params
		      params.require(:survey).permit(:mood)
		    end
			
		    def authenticate_user_from_token!
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