namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(first_name: "Tim",
                 last_name: "Joe",
                 email: "contact@roundview.co",
                 password: "password",
                 password_confirmation: "password",
                 business_name: "Roundview",
                 business_zipcode: "11211",
                 business_address: "140 Hope St, Brooklyn, NY")
    99.times do |n|
      email = "fake-#{n+1}@roundview.co"
      password  = "password"
      User.create!(first_name: Faker::Name.first_name,
                  last_name: Faker::Name.last_name,
                  email: email,
                  password: password,
                  password_confirmation: password,
                  business_name: Faker::Company.name,
                  business_zipcode: Faker::Address.zip_code,
                  business_address: Faker::Address.street_address)
    end

    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.conversations.create!(content: content) }
    end
    
    my_survey = Survey::Survey.new do |survey|
      survey.name = "Test survey" 
      survey.description = "Auto populated survey"
      survey.active = true
    end
    
    question_1 = Survey::Question.new do |question|
      question.text = 'How has business been this week?'
        question.options = [
        Survey::Option.new(:text => 'Terrible'),
        Survey::Option.new(:text => 'Fantastic')
      ]
    end

    question_2 = Survey::Question.new do |question|
      question.text = 'How much time did you spend doing paperwork today?'
      question.options = [
        Survey::Option.new(:text => 'Less than an hour'),
        Survey::Option.new(:text => 'More than an hour')
      ]
    end
    my_survey.questions = [question_1, question_2]
    my_survey.save!
    
    30.times do
        users.each do |user|
          attempt = Survey::Attempt.new(:survey => my_survey, :participant => user)
          response1 = Survey::Option.find_by_id(rand(1..2))
          attempt.answers = [Survey::Answer.new(:option=>response1, :question=> question_1)]
          response2 = Survey::Option.find_by_id(rand(3..4))
          attempt.answers = [Survey::Answer.new(:option=>response2, :question=> question_2)]
        end   
    end 

  end
end


# $ bundle exec rake db:reset
# $ bundle exec rake db:populate
# $ bundle exec rake test:prepare


