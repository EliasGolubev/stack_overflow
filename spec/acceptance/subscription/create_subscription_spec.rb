require_relative '../acceptance_helper.rb'

feature 'Create subscriptions with question' do 
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question){ create(:question, user: author) }

  context 'non authenticated user' do 
    scenario 'can\'t subscribe the question' do 
      visit question_path(question)
      within '.question-show' do
        expect(page).to_not have_link 'Subscribe'
      end
    end
  end

  context 'autenticated user' do 
    scenario 'can create subscriptions with question', js: true do
      sign_in user
      visit question_path(question)
      within '.question-show' do 
        expect(page).to have_link 'Subscribe'
        
        click_on 'Subscribe'
        wait_for_ajax
        expect(page).to have_link 'Unsubscribe'
      end
    end
  end

  context 'with subscribed user', js: true do 
    scenario 'push email subscribed user when create answer question' do 
      sign_in user
      visit question_path(question)
      fill_in 'Ask Answer', with:'ask text text'
      click_on 'Ask'
      wait_for_ajax

      open_email(author.email)
      expect(current_email).to have_content 'ask text text'
    end
  end
end
