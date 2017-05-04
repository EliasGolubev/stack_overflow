require_relative '../acceptance_helper.rb'

feature 'user can sign in facebook' do 
  before { visit new_user_session_path }

  scenario 'user can sign in vith valid mock' do
    
    mock_auth_hash('facebook', 'John Doe','test@mail.com')
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
  end

  scenario 'user can not sign in vith invalid mock' do
    mock_auth_invalid_hash('facebook')
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Invalid provider'
  end
end
