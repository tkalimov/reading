module Api
	module V1
		class BusinessesController < ApplicationController
		    after_filter :cors_set_access_control_headers
			  
		    def index
		        @businesses = Business.all
		        render json: @businesses
		    end

		    def show
		        @business = Business.find(params[:id])

		        render json: @business
		    end

		    def create
		        @business = Business.new(business_params)

		        if @business.save
		          render json: @business, status: :created
		        else
		          render json: @business.errors, status: :unprocessable_entity
		        end
		    end

		    # PATCH/PUT /businesss/1
		    # PATCH/PUT /businesss/1.json
		    def update
		        @business = Business.find(params[:id])

		        if @business.update(params[:business])
		          head :no_content
		        else
		          render json: @business.errors, status: :unprocessable_entity
		        end
		    end

		    # DELETE /businesss/1
		    # DELETE /businesss/1.json
		    def destroy
		        @business = Business.find(params[:id])
		        @business.destroy

		        head :no_content
		    end
				
		    
		    private 
		      
		    def business_params
		          params.require(:business).permit(:name, :category, :address1, :address2, :city, :state, :zip, :phone_number)
		    end 
		end 
	end
end 
