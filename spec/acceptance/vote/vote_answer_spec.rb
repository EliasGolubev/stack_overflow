require_relative '../acceptance_helper.rb'

feature 'Vote answer', %q{
  In order to show my attitude to answer
  As an user
  I'd like to be able to vote
} do
  given!(:question){ create(:question) }
  given!(:answer_first){ create(:answer, question: question) }
  given(:user){ create(:user) }

  describe 'Author answer' do

    given(:author){ answer_first.user }
    before do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'don\'t vote his answer', js: true do
      within '.answers' do
        expect(page).to_not have_content('UP')
      end
    end

    scenario 'don\'t re-vote answer', js: true do
      within '.answers' do
        expect(page).to_not have_content('DOWN')
      end
    end
  end

  describe 'Non author question' do
    given!(:answer_second){ create(:answer, question: question) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'vote up answer', js: true do
      within "#answer-vote-#{answer_first.id}" do
        click_on 'UP'

        expect(page).to have_content('1')
      end

      within "#answer-#{answer_first.id}" do
        expect(page).to_not have_content('You can\'t vote')
      end

      within "#answer-#{answer_second.id}" do
        expect(page).to have_content('0')
      end
    end

    scenario 'vote down answer', js: true do
      within "#answer-vote-#{answer_first.id}" do
        click_on 'DOWN'

        expect(page).to have_content('-1')
      end

      within "#answer-#{answer_first.id}" do
        expect(page).to_not have_content('You can\'t vote')
      end

      within "#answer-#{answer_second.id}" do
        expect(page).to have_content('0')
      end
    end

    scenario 'vote once answer', js: true do
      within "#answer-vote-#{answer_first.id}" do
        click_on 'DOWN'
        wait_for_ajax
        click_on 'DOWN'
        wait_for_ajax

        expect(page).to have_content('-1')
      end
      within "#answer-#{answer_first.id}" do
        expect(page).to have_content('You can vote once')
      end
      within "#answer-vote-#{answer_second.id}" do
        expect(page).to have_content('0')
      end
      within "#answer-#{answer_second.id}" do
        expect(page).to_not have_content('You can vote once')
      end
    end

    scenario 're-vote answer after vote', js: true do
      within "#answer-vote-#{answer_first.id}" do
        click_on 'DOWN'
        wait_for_ajax
        click_on 'Re-Vote'
        wait_for_ajax

        expect(page).to have_content('0')
      end
    end
    scenario 'don\'t re-vote answer before vote', js: true do
      within "#answer-vote-#{answer_first.id}" do
        click_on 'Re-Vote'
        wait_for_ajax

        expect(page).to have_content('0')
      end
      within "#answer-#{answer_first.id}" do
        expect(page).to have_content('You must vote')
      end
      within "#answer-vote-#{answer_second.id}" do
        expect(page).to_not have_content('You must vote')
      end
    end
  end

  describe 'Sign out user' do
    before do
      visit question_path(question)
    end

    scenario 'don\'t positive vote the answer', js: true do
      expect(page).to_not have_content('UP')
    end

    scenario 'don\'t negative vote the answer', js: true do
      expect(page).to_not have_content('DOWN')
    end

    scenario 'don\'t re-vote answer', js: true do
      expect(page).to_not have_content('Re-Vote')
    end
  end
end
