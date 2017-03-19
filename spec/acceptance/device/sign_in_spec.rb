require 'rails_helper.rb'

feature 'User sign in', %q{
  In order to be able to ask question
  As an User
  I want to be able to sign in
} do 

  given(:user) { create :user }

  scenario 'Registered user can sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Registered user not fill email field' do
    visit new_user_session_path
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content('Invalid Email or password.')
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Unregistered user can not sign in' do
    visit new_user_session_path
    fill_in 'Email',      with: Faker::Internet.email
    fill_in 'Password',   with: Faker::Internet.password
    click_on 'Log in'

    expect(page).to have_content('Invalid Email or password.')
    expect(current_path).to eq new_user_session_path
  end

  scenario 'No logged user can see Sign in button on root page' do 
    visit root_path

    expect(page).to have_content('Sign in')
  end

  scenario 'No logged user can see Sign in button on question page' do
    question = create(:question)
    
    visit question_path(question)

    expect(page).to have_content('Sign in') 
  end

  scenario 'Logged user can not see Sign in button on root page' do 
    
    sign_in(user)
    visit root_path

    expect(page).to_not have_content('Sign in')
  end

  scenario 'Logged user can not see Sign in button on question page' do
    question = create(:question)

    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_content('Sign in')
  end
end
