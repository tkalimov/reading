# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    user_id 1
    title "MyString"
    url "MyString"
    word_count 1
    time_added "2014-03-26 17:28:50"
    time_read "2014-03-26 17:28:50"
    categories "MyString"
  end
end
