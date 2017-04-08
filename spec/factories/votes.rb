FactoryGirl.define do
  factory :positive, class: 'Vote' do
    user_vote "1"
    user
    votable
  end

  factory :negative, class: 'Vote' do
    user_vote "-1"
    user
    votable
  end
end