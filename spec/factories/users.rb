# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username               Faker::Internet.user_name
    email                  Faker::Internet.email
    password               "12345678"
    password_confirmation  "12345678"
  end
end
