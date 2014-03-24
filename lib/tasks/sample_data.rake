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
                 )
    
    #Create 50 users with  
    50.times do |n|
      email = "fake-#{n+1}@roundview.co"
      password  = "password"
      User.create!(first_name: Faker::Name.first_name,
                  last_name: Faker::Name.last_name,
                  email: email,
                  password: password,
                  password_confirmation: password,
                  )
    end
    
    #Generate 2 conversation posts for every user
    users = User.all
    
    2.times do
      category1 = "Personal"
      category2 = "Vertical"
      category3 = "Local"
      users.each do |user| 
        user.conversations.create!(content: Faker::Lorem.sentence(5), category: category1, created_at:rand(6.weeks).ago)
        user.conversations.create!(content: Faker::Lorem.sentence(5), category: category2, created_at:rand(6.weeks).ago)
        user.conversations.create!(content: Faker::Lorem.sentence(5), category: category3, created_at:rand(6.weeks).ago)
      end 
    end

    #Create conversations for our test user
    30.times do 
      content = Faker::Lorem.sentence(5)
      User.first.conversations.create!(content:content)
    end 
  end
end