module Api
	module V1
		class SurveysController < ApplicationController
			

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
		      render json: Survey.update(params[:id], survey_params)
		    end

		    def destroy
		      render json: Survey.destroy(params[:id])
		    end

		 	

		  	private

		    def survey_params
		      params.require(:survey).permit(:mood)
		    end
		end
	end 
end