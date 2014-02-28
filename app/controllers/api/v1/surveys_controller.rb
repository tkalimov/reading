module Api
	module V1
		class SurveysController < ApplicationController
			after_filter :cors_set_access_control_headers
			before_filter :authenticate_user_from_token!, :except => [:admin_survey, :admin_question]
      		before_filter :authenticate_api_v1_user!, :except => [:admin_survey, :admin_question]
			helper_method :survey, :participant

			def index
				output = Array.new
				questions = survey.questions
				i = 0
				questions.each do |question|
					midput = {question_id: question.id, question_text: question.text, options: []}
					question.options.each do |option|
						midput[:options].push(option.text)
					end
					output[i] = midput
					i += 1
				end

				render json: output

			end
			
			def admin_survey
				question = Survey::Question.new do |question|
					  question.text = params[:survey][:question_text]
					  # by default when we don't specify the weight of a option
					  # its value is equal to one
					  question.options = [
					    Survey::Option.new(:text => params[:survey][:question_option1],  :correct => false),
					    Survey::Option.new(:text => params[:survey][:question_option2], :correct => true),
					  ]
				end
				survey.questions.push(question)

				if survey.save!
					render json: survey
				else 
					render json: survey.errors, status: :unprocessable_entity
				end
			end 
			

			def create 
				@attempt = Survey::Attempt.new(:survey => survey, :participant => participant)
				@response = Survey::Option.find_by_text(params[:option][:text])
				@question = Survey::Question.find_by_id(params[:option][:question_id])
				@attempt.answers = [Survey::Answer.new(:option => @response, :question => @question)]
				if @attempt.save
					render :json=> {:success=>true, :response=>@response.text, :created_at=>@response.created_at, :response_count=>Survey::Answer.where(:question == @question, :survey == survey).count}
				else 
					render json: @attempt.errors, status: :unprocessable_entity
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

				def participant
	    			@participant ||= current_api_v1_user
	  			end

	  			def survey
			    	@survey ||= Survey::Survey.active.first
				end

			    def survey_params
			      params.require(:survey).permit(:name, :description, :attempts_number, :finished, :active)
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