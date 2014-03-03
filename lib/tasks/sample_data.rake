namespace :db do
  desc "Fill database with sample data"
  #To populate the database, run the following two commands:
  # $ rake db:reset
  # $ rake db:populate
  
  task populate: :environment do
    #First user for our Testing
    User.create!(first_name: "Tim",
                 last_name: "Joe",
                 email: "contact@roundview.co",
                 password: "password",
                 password_confirmation: "password",
                 business_name: "Roundview",
                 business_zipcode: "11211",
                 business_address: "140 Hope St, Brooklyn, NY",
                 business_verticals: ["bar"])
    #Create 50 users with same verticals 
    50.times do |n|
      email = "fake-#{n+1}@roundview.co"
      password  = "password"
      department1 = "restaurant"
      department2 = "bar"
      department3 = "attorney"
      User.create!(first_name: Faker::Name.first_name,
                  last_name: Faker::Name.last_name,
                  email: email,
                  password: password,
                  password_confirmation: password,
                  business_name: Faker::Company.name,
                  business_zipcode: Faker::Address.zip_code,
                  business_address: Faker::Address.street_address,
                  business_verticals: [department1, department2, department3])
    end
    
    #Create 50 users with same zipcode
    50.times do |n|
      email = "fake2-#{n+1}@roundview.co"
      password  = "password"
      department1 = Faker::Commerce.department
      department2 = Faker::Commerce.department
      department3 = Faker::Commerce.department
      User.create!(first_name: Faker::Name.first_name,
                  last_name: Faker::Name.last_name,
                  email: email,
                  password: password,
                  password_confirmation: password,
                  business_name: Faker::Company.name,
                  business_zipcode: '11211',
                  business_address: Faker::Address.street_address,
                  business_verticals: [department1, department2, department3])
    end

    #Generate 2 conversation posts for every user
    users = User.all
    
    2.times do
      category1 = "Personal"
      category2 = "Vertical"
      category3 = "Local"
      users.each do |user| 
        user.conversations.create!(content: Faker::Lorem.sentence(5), category: category1)
        user.conversations.create!(content: Faker::Lorem.sentence(5), category: category2)
        user.conversations.create!(content: Faker::Lorem.sentence(5), category: category3)
      end 
    end
    
 
    #GENERATE NEW ACTIVE SURVEY
    my_survey = Survey::Survey.new do |survey|
      survey.name = "Test survey" 
      survey.description = "Auto populated survey"
      survey.active = true
    end
    
    #Generate new question number 1
    question_1 = Survey::Question.new do |question|
      question.text = 'How has business been this week?'
        question.options = [
        Survey::Option.new(:text => 'Terrible'),
        Survey::Option.new(:text => 'Fantastic')
      ]
    end


    #Generate new question number 2
    question_2 = Survey::Question.new do |question|
      question.text = 'How much time did you spend doing paperwork today?'
      question.options = [
        Survey::Option.new(:text => 'Less than an hour'),
        Survey::Option.new(:text => 'More than an hour')
      ]
    end

    #SAVE SURVEY
    my_survey.questions = [question_1, question_2]
    my_survey.save!
    
    #Generate responses to both questions by every user
    users.each do |user|
      attempt = Survey::Attempt.new(:survey => my_survey, :participant => user)
      response1 = Survey::Option.find_by_id(rand(1..2))
      answer1 = Survey::Answer.new(:option=>response1, :question=> question_1)
      response2 = Survey::Option.find_by_id(rand(3..4))
      answer2 = Survey::Answer.new(:option=>response2, :question=> question_2)
      attempt.answers = [answer1, answer2]
      attempt.save
    end  
  end
end
