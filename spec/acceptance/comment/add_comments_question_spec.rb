require_relative '../acceptance_helper.rb'

feature 'Add comments to question', %q{
  In order to comments question
  As a autorizated user
  I'd like to be able to comments
} do
  given(:question){ create(:question) }
  given(:user){ create(:user) }

  scenario 'autorizated user can comments question', js: true do
    sign_in user
    visit question_path(question)

    within '.question-comments-block' do
      fill_in 'Comment text', with: 'Test comments'
      click_on 'Create Comment'
    end


    expect(page).to have_content('Test comments')
  end

  scenario 'autorizated user create not valid comments', js: true do 
    sign_in user
    visit question_path(question)
    within '.question-comments-block' do
      fill_in 'Comment text', with: nil
      click_on 'Create Comment'
    end
    
    expect(page).to have_content('Body can\'t be blank')
  end

  scenario 'non autorizated user can\'t comments question', js: true do 
    visit question_path(question)
    within '.question-comments-block' do
      fill_in 'Comment text', with: 'Test comments'
      click_on 'Create Comment'
    end

    expect(page).to_not have_content('Test comments')
  end
end