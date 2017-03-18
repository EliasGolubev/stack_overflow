require 'rails_helper'

feature 'Create answer', %q{
  In order to answer the question
  As an authenticated user
  I have to be able to create answer
  } do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Sign in user can answer question' do 
    sign_in(user)

    visit question_path(question)
    fill_in 'Ask Answer', with:'ask text text'
    click_on 'Ask'

    expect(page).to have_content('ask text text')
  end

  scenario 'Non autenficate user can\'t ask answer' do 
    visit question_path(question)
    click_on 'Ask'
    
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end