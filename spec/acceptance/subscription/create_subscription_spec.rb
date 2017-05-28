require_relative '../acceptance_helper.rb'

feature 'Create subscriptions with question' do 
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question){ create(:question, user: author) }

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
end