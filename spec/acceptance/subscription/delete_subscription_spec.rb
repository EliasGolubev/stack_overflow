require_relative '../acceptance_helper.rb'

feature 'Delete subscriptions with question' do
  given(:user) { create(:user) }
  given(:question){ create(:question) }

  context 'with user subscribe question' do 
    given!(:subscription){ create(:subscription, question: question, user: user) }

    scenario 'can unsubscribe question', js: true do 
      sign_in user
      visit question_path(question)
      within '.question-show' do 
        expect(page).to have_link 'Unsubscribe'
        click_on 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
      end
    end
  end
end 