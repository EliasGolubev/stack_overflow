require_relative '../acceptance_helper.rb'

feature 'Destroy answer', %q{
  In order to delete answer
  As an authenticated user
  I have to click on the delete button
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Sign in user delete his question', js: true do 
    sign_in(user)

    visit question_path(question)
    fill_in 'Ask Answer', with: 'answer text'
    click_on 'Ask'

    click_link 'Delete'

    expect(page).to_not have_content('answer text')
  end

  scenario 'Sign in user can\'t delete someone else\'s question', js: true do
    sign_in(user)
    
    visit(question_path(question))
    fill_in 'Ask Answer', with: 'answer text'
    click_on 'Ask'
    click_on 'Sign out'
    visit(question_path(question))

    expect(page).to have_content('answer text')
    expect(page).to_not have_content('Delete')
  end

  context "mulitple sessions" do
    scenario "delete answer on another user's page", js: true do
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
      Capybara.using_session('user') do
        click_link 'Delete'

        expect(page).to_not have_content('ask text text')
      end
      Capybara.using_session('guest') do
        expect(page).to_not have_content('ask text text')
      end
    end
  end
end