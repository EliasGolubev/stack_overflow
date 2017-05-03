require_relative '../acceptance_helper.rb'

feature 'User registration', %q{
  In order to be able to sign in
  As an User
  I want to be able to registration
} do 

  scenario 'User fill all registration field' do
    registration_user
    open_email 'user@email.com'
    current_email.click_link 'Confirm my account'

    expect(page).to have_content('Your email address has been successfully confirmed.')
    fill_in 'Email', with: 'user@email.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'User not fill username' do
    registration_user(username: nil)

    expect(page).to have_content('Username can\'t be blank')
    expect(current_path).to eq user_registration_path
  end

  scenario 'User not fill email' do
    registration_user(email: nil)

    expect(page).to have_content('Email can\'t be blank')
    expect(current_path).to eq user_registration_path
  end

  scenario 'User not fill password' do
    registration_user(password: nil)
    
    expect(page).to have_content('Password can\'t be blank')
    expect(page).to have_content('Password confirmation doesn\'t match Password')
    expect(current_path).to eq user_registration_path
  end

  scenario 'User not fill conf password' do
    registration_user(password_confirmation: nil)
    
    expect(page).to have_content('Password confirmation doesn\'t match Password')
    expect(current_path).to eq user_registration_path
  end

  scenario 'User fill email already exist' do
    user = create(:user)

    registration_user(username:              user.username,
                      email:                 user.email,
                      password:              user.password,
                      password_confirmation: user.password_confirmation)    

    expect(page).to have_content('Email has already been taken')
    expect(current_path).to eq user_registration_path
  end

  scenario 'User password less six symbol' do
    registration_user(password: '123', password_confirmation: '123')

    expect(page).to have_content('Password is too short (minimum is 6 characters)')
    expect(current_path).to eq user_registration_path
  end

  scenario 'No logged user can see button Sign up on root page' do
     visit root_path

     expect(page).to have_content('Sign up')
  end

  scenario 'No logged user can see button Sign up on question page' do
    question = create(:question)

    visit question_path(question)

    expect(page).to have_content('Sign up')
  end

  scenario 'Logged user can not see button Sign up on root page' do 
    user = create(:user)

    sign_in(user)
    visit root_path

    expect(page).to_not have_content('Sign up')
  end

  scenario 'Logged user can not see button Sign up on question page' do 
    question = create(:question)
    user = create(:user)

    sign_in(user)
    visit root_path

    expect(page).to_not have_content('Sign up')
  end
end
