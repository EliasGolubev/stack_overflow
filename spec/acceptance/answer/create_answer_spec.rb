require_relative '../acceptance_helper.rb'

feature 'User create answer', %q{
  In order to exchange my knowledge
  As an authenticated user
  I have to be able to create answer
  } do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Autenticated user can answer question', js: true do 
    sign_in(user)

    visit question_path(question)
    fill_in 'Ask Answer', with:'ask text text'
    click_on 'Ask'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content('ask text text')
  end

  scenario 'Non autenficate user can\'t ask answer' do 
    visit question_path(question)
    click_on 'Ask'
    
    expect(page).to have_content('You are not authorized to access this page.')
  end

  scenario 'User try to create invalid answer', js: true do 
    sign_in(user)

    visit question_path(question)
    click_on 'Ask'

    expect(page).to have_content('Body can\'t be blank')
  end

  scenario 'User create valid answer after invalid answer', js: true do 
    sign_in(user)

    visit question_path(question)
    click_on 'Ask'
    fill_in 'Ask Answer', with:'ask text text'
    click_on 'Ask'

    expect(page).to have_content('ask text text')
    expect(page).to_not have_content('Body can\'t be blank')
  end

  context "mulitple sessions" do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
      Capybara.using_session('guest') do
        visit question_path(question)
      end
      Capybara.using_session('user') do 
        fill_in 'Ask Answer', with:'ask text text'
        click_on 'Ask'

        expect(page).to have_content('ask text text')
      end
      Capybara.using_session('guest') do
        expect(page).to have_content('ask text text')
      end
    end
  end
end