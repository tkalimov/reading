module Api
	module V1
		class SurveysController < ApplicationController
			after_filter :cors_set_access_control_headers
			
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


			def cors_set_access_control_headers
		    	headers['Access-Control-Allow-Origin'] = 'null'
		    	headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE'
			end
		end
	end 
end