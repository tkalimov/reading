module Api
	module V1
		class SurveysController < ApplicationController
			after_filter :cors_set_access_control_headers
			before_filter :authenticate_user_from_token!
      		before_filter :authenticate_api_v1_user!
			helper_method :survey, :participant, :question

			def index
				@answers =  Survey::Answer.where(:question == question, :survey == survey)
				render :json=> {:answers=>@answers, :question=>question, :options=>question.options}
			end
			
			def create 
				@attempt = Survey::Attempt.new(:survey => survey, :participant => participant)
				@response = Survey::Option.find_by_text(params[:option][:text])
				@attempt.answers = [Survey::Answer.new(:option => @response, :question => question)]
				if @attempt.save
					render :json=> {:success=>true, :response=>@response.text, :created_at=>@response.created_at, :response_count=>Survey::Answer.where(:question == question, :survey == survey).count}
				else 
					render json: @attempt.errors, status: :unprocessable_entity
				end 	

			end

			#NEED TO delete?
			def show
		    	@survey = Survey.find(params[:id])
		    	render json: @survey
		  	end

		    #NEED TO delete? 
		    def update
		    	@survey = Survey.find(params[:id])
		    	 
		    	if @survey.update(params[:survey])
          			head :no_content
        		else
          			render json: @survey.errors, status: :unprocessable_entity
        		end
		    end
			
			#NEED TO UPDATE
		    def destroy
		        @survey = Survey.find(params[:id])
        		@survey.destroy
        		head :no_content
		    end
			
		  	private

				def participant
	    			@participant ||= current_api_v1_user
	  			end

	  			def survey
			    	@survey ||= Survey::Survey.active.first
				end

				def question
			    	@question ||= Survey::Question.last
				end

			    def survey_params
			      params.require(:option).permit(:text)
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