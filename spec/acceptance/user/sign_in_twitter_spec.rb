require_relative '../acceptance_helper.rb'

feature 'Sign in with twitter' do
  before { visit new_user_session_path }

  scenario 'user can sign in vith valid hash mock auth' do 
    mock_auth_hash('twitter', 'John Doe',nil)
    click_on 'Sign in with Twitter'
    
    fill_in 'email', with: 'test@email.com'
    click_on 'Submit'

    open_email 'test@email.com'
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed'

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
  end

  scenario 'user can not sign in vith invalid hash mock auth' do 
    mock_auth_invalid_hash('twitter')
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Invalid provider'
  end
end