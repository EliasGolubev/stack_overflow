require_relative '../acceptance_helper.rb'

feature 'User edit question', %q{
  In order to be able to edit my question text
  As an User
  I want to be able to edit my question
} do 
  
  before do 
    create(:question)
    create(:second_question)
  end

  scenario 'User can show all questions title on root page' do    
    visit root_path

    expect(page).to have_content('MyString') 
    expect(page).to have_content('MySecondString')  
  end

  scenario 'User can\'t see all questions body on root page' do 
    visit root_path

    expect(page).to_not have_content('MyText')
    expect(page).to_not have_content('MySecondText')
  end

  scenario 'User can show question on question page' do 
    question = create(:question)
    visit question_path(question)

    expect(page).to have_content('MyString') 
    expect(page).to have_content('MyText') 
  end
end