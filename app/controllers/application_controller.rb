class ApplicationController < ActionController::API
	include ActionController::MimeResponds
	include ActionController::StrongParameters
	after_filter :cors_set_access_control_headers

	def cors_set_access_control_headers
    	headers['Access-Control-Allow-Origin'] = 'null'
    	headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE'
	end
end
