require_relative '../acceptance_helper.rb'

feature 'Set best answer', %q{
  In order to best answer
  As question autor
  I have to be able to set best answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer1) { create(:answer, question: question, best: true) }
  given!(:answer2) { create(:answer, question: question) }
  describe 'Autorization user' do
    context 'with autor questions' do
      before do
        sign_in question.user
        visit question_path(question)
      end

      scenario 'can see button "Best" answers' do
        expect(page).to have_content("Best")
      end

      scenario 'can made best answer', js: true do
        within "div#answer-#{answer2.id}" do
          click_on 'Best'
          wait_for_ajax

          expect(page).to have_content('best')
        end

        within "div#answer-#{answer1.id}" do
          expect(page).to_not have_content('best')
        end
      end

      scenario 'can made best answer, and best answer show first answers lists', js: true do
        within "div#answer-#{answer2.id}" do
          click_on 'Best'
          wait_for_ajax
        end

        expect(first(".answer")).to have_content "best"
        expect(first(".answer")).to have_selector "#answer-#{answer2.id}"
      end
    end

    context 'with no autor question' do
      before do
        sign_in user
        visit question_path(question)
      end
      scenario 'can\'t see button "Best" answers', js: true do
        expect(page).to_not have_content("Best")
      end

      scenario 'can see best label', js: true do
        within "div#answer-#{answer1.id}" do
          expect(page).to have_content('best')
        end
      end
    end
  end

  describe 'Non autorization user' do
    before do
      visit question_path(question)
    end
    scenario 'can\'t see button "Best" answers', js: true do
      expect(page).to_not have_content("Best")
    end

    scenario 'can see best label' do
      within "div#answer-#{answer1.id}" do
        expect(page).to have_content('best')
      end
    end
  end
end