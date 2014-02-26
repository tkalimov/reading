# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :business do
    name "MyString"
    street_address "MyString"
    city "MyString"
    state "MyString"
    zipcode 1
    phone "MyString"
  end
end
