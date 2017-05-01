FactoryGirl.define do
  factory :comment do
    user
    body "Text comment"
    association :commentable, factory: :question
  end
end
