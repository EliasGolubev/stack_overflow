require_relative '../acceptance_helper.rb'

feature 'User sign out', %q{
  In order to be able to end seassion
  As an User
  I want to be able to sign out
} do 

  scenario 'Logged user can see sign out at root page' do 
    user = create(:user)
    sign_in(user)

    visit root_path

    expect(page).to have_content('Sign out')
  end

  scenario 'No logged user can not see sign out button at question page' do
    question = create(:question)

    visit question_path(question)

    expect(page).to_not have_content('Sign out')
  end

  scenario 'Logged user can sign out' do
    user = create(:user)
    sign_in(user)

    visit root_path
    click_on 'Sign out'

    expect(page).to have_content('Signed out successfully.')
  end
end