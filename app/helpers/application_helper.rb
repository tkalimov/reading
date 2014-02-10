module ApplicationHelper
	
	def cors_set_access_control_headers
          headers['Access-Control-Allow-Origin'] = 'http://localhost:5000'
          headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE'
    end
end
