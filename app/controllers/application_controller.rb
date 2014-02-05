class ApplicationController < ActionController::API
	include ApplicationHelper
	include ActionController::MimeResponds
	include ActionController::StrongParameters
end
