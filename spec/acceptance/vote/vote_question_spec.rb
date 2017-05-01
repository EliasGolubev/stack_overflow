require_relative '../acceptance_helper.rb'

feature 'Vote question', %q{
  In order to show my attitude to question
  As an user
  I'd like to be able to vote
} do
  given(:question){ create(:question) }
  given(:user){ create(:user) }

  describe 'Author question' do

    given(:author){ question.user }
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'don\'t vote his question', js: true do
      expect(page).to_not have_content('UP')
    end

    scenario 'don\'t re-vote question', js: true do
      expect(page).to_not have_content('DOWN')
    end
  end

  describe 'Non author question' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'vote question up', js: true do
      within '.question-vote' do
        click_on 'UP'

        expect(page).to have_content('1')
      end

      within '.question-show' do
        expect(page).to_not have_content('You can\'t vote')
      end
    end

    scenario 'vote question down', js: true do
      within '.question-vote' do
        click_on 'DOWN'

        expect(page).to have_content('-1')
        
      end
      within '.question-show' do
        expect(page).to_not have_content('You can\'t vote')
      end
    end

    scenario 'vote question once', js: true do
      within '.question-vote' do
        click_on 'DOWN'
        wait_for_ajax
        click_on 'DOWN'
        wait_for_ajax
        expect(page).to have_content('-1')
      end

      within '.question-show' do
        expect(page).to have_content('You can vote once')
      end
    end

    scenario 're-vote question after vote', js: true do
      within '.question-vote' do
        click_on 'DOWN'
        wait_for_ajax
        click_on 'Re-Vote'
        wait_for_ajax

        expect(page).to have_content('0')
      end
    end
    scenario 'don\'t re-vote question before vote', js: true do
      within '.question-vote' do
        click_on 'Re-Vote'
        wait_for_ajax

        expect(page).to have_content('0')     
      end

      within '.question-show' do
        expect(page).to have_content('You must vote')
      end
    end
  end

  describe 'Sign out user' do
    before do
      visit question_path(question)
    end

    scenario 'don\'t positive vote the question', js: true do
      expect(page).to_not have_content('UP')
    end

    scenario 'don\'t negative vote the question', js: true do
     expect(page).to_not have_content('DOWN')
    end

    scenario 'don\'t re-vote question', js: true do
      expect(page).to_not have_content('Re-Vote')
    end
  end
end
