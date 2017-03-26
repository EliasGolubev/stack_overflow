# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    user
    question
    body "MyText"
    best false
  end

  factory :invalid_answer, class: Answer do 
    body nil
    best false
  end
end
