require 'rails_helper'

feature 'User create question', %q{
  In order to be able to get a answer
  As an User
  I want to be able to create question
} do 

  scenario 'Logged user can see New question button on the root page' do 
    user = create(:user)
    sign_in(user)

    visit root_path
    
    expect(page).to have_content('New question')
  end

  scenario 'Logged user can click New question button' do
    user = create(:user)
    sign_in(user)

    visit root_path
    click_on 'New question'

    expect(page).to have_content('Title')
    expect(page).to have_content('Question text')
    expect(current_path).to eq new_question_path
  end 

  scenario 'Logged user fill title and body question' do 
    user = create(:user)
    sign_in(user)

    visit new_question_path

    fill_in 'Title',          with: 'Title question'
    fill_in 'Question text',  with: 'Text text text'
    click_on 'Ask question'

    expect(page).to have_content('Title question')
    expect(page).to have_content('Text text text')
  end

  scenario 'Logged user not fill title question' do
    user = create(:user)
    sign_in(user)

    visit new_question_path

    fill_in 'Title',          with: nil
    fill_in 'Question text',  with: 'Text text text'
    click_on 'Ask question'

    expect(page).to have_content('Title can\'t be blank')
  end

  scenario 'Logged user not fill body question' do 
    user = create(:user)
    sign_in(user)

    visit new_question_path

    fill_in 'Title',          with: 'Text text text'
    fill_in 'Question text',  with: nil
    click_on 'Ask question'

    expect(page).to have_content('Body can\'t be blank')
  end

  scenario 'Not logged user can\'t create question' do 
    visit new_question_path
    
    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(current_path).to eq new_user_session_path
  end

end