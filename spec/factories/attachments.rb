# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    file File.new("#{Rails.root}/spec/acceptance/file/testing_file.txt")
  end
end
