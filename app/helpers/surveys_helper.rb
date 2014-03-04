module SurveysHelper
	
	def individual_results
		individual_results = Hash.new
		responses = Array.new
		attempts = Survey::Attempt.where(:survey => survey, :participant => participant)
		survey.questions.each do |question|
			attempts.each do |attempt|
				attempt.answers.each do |answer|
					if answer.question_id == question.id
						responses.push(answer)
					end 
				end 
			end 
			responses.sort_by(&:created_at)
			individual_results[question.text] = responses
			responses =[]
		end 
		return individual_results
	end 

#Model that stores all of the responses for verticals 
#It should be able to pull -- for a given question, a timelien 

	def vertical_results
		vertical_results = Hash.new
		all_dates = Array.new
		Survey::Answer.all.each do |answer|
			all_dates.push(answer.created_at.strftime("%m/%d/%Y"))
		end
		unique_dates = all_dates.uniq
		survey.questions.each do |question|
			dated_results = Hash.new
			unique_dates.each do |date|
				responses = Array.new
				participant.business_verticals.each do |vertical|
					competitors = User.where("'#{vertical}' = ANY (business_verticals)")
					competitors.each do |competitor|
						attempts = Survey::Attempt.where(:survey => survey, :participant => competitor)
						attempts.each do |attempt|
							attempt.answers.each do |answer|
								if answer.question_id == question.id && date == answer.created_at.strftime("%m/%d/%Y")
									responses.push(answer)
								end 
							end 
						end 
					end	
				end 
				dated_results[date] = responses
			end
			vertical_results[question.text] = dated_results 
		end 
		return vertical_results
	end 

	def neighborhood_results
		neighborhood_results = Hash.new
		responses = Array.new 
		competitors = User.where(:business_zipcode => participant.business_zipcode)
		survey.questions.each do |question|
			competitors.each do |competitor|
				attempts = Survey::Attempt.where(:survey => survey, :participant => competitor)			
				attempts.each do |attempt|
					attempt.answers.each do |answer|
						if answer.question_id == question.id
							responses.push(answer)
						end 
					end 
				end 
			end
			responses.sort_by(&:created_at)
			neighborhood_results[question.text] = responses
			responses =[]
		end 

		return neighborhood_results
	end 

end 