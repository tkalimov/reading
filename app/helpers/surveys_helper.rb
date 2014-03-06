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


	def vertical_results
		vertical_results = Hash.new
		participant.business_verticals.each do |vertical|
			competitors = User.where("'#{vertical}' = ANY (business_verticals)")
			competitors.each do |competitor|
				attempts = Survey::Attempt.where(:survey => survey, :participant => competitor)
				attempts.each do |attempt|
					attempt.answers.each do |answer|
						if vertical_results[answer.question_id]
							if vertical_results[answer.question_id][answer.date]
								if vertical_results[answer.question_id][answer.date][answer.option_id]
									vertical_results[answer.question_id][answer.date][answer.option_id] = vertical_results[answer.question_id][answer.date][answer.option_id] + 1
								else 
									vertical_results[answer.question_id][answer.date][answer.option_id] = 1
								end 
							else 
								vertical_results[answer.question_id][answer.date] = {answer.option_id => 1}
							end
						else 
							vertical_results[answer.question_id] = {answer.date => {answer.option_id => 1}}
						end 
					end 
				end 
			end	
		end

		return vertical_results
	end 

	def neighborhood_results
		neighborhood_results = Hash.new
		competitors = User.where(:business_zipcode => participant.business_zipcode)
		competitors.each do |competitor|
			attempts = Survey::Attempt.where(:survey => survey, :participant => competitor)
			attempts.each do |attempt|
				attempt.answers.each do |answer|
					if neighborhood_results[answer.question_id]
						if neighborhood_results[answer.question_id][answer.date]
							if neighborhood_results[answer.question_id][answer.date][answer.option_id]
								neighborhood_results[answer.question_id][answer.date][answer.option_id] = neighborhood_results[answer.question_id][answer.date][answer.option_id] + 1
							else 
								neighborhood_results[answer.question_id][answer.date][answer.option_id] = 1
							end 
						else 
							neighborhood_results[answer.question_id][answer.date] = {answer.option_id => 1}
						end
					else 
						neighborhood_results[answer.question_id] = {answer.date => {answer.option_id => 1}}
					end 
				end 
			end 
		end	
		return neighborhood_results
	end 
	

end 