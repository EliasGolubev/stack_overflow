require_relative '../acceptance_helper.rb'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like at be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  
  scenario 'Unauthenticaded user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
  
  describe 'Authenticated user' do
    context 'with user answer' do
      before do
        sign_in answer.user
        visit question_path(question)
      end
      scenario 'sees link to edit his answer' do

        within '.answers' do
          expect(page).to have_content 'Edit'
        end
      end

      scenario 'try to edit his answer', js: true do
        click_on 'Edit'

        within '.answers' do
          fill_in 'Edit Answer', with: 'edited answer'
          click_on 'Update Answer'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea#answer_body'
        end
      end
    end

    context 'with other user\'s answers' do
      scenario 'try to edit answers', js: true do
        sign_in user
        visit question_path(question)

        within '.answers' do
          expect(page).to have_content answer.body
          expect(page).to_not have_content 'Edit'
          expect(page).to_not have_selector 'textarea#answer_body'
        end
      end
    end
  end
end