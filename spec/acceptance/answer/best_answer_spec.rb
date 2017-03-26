require_relative '../acceptance_helper.rb'

feature 'Set best answer', %q{
  In order to best answer
  As question autor
  I have to be able to set best answer
} do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  describe 'Autorization user' do
    given (:user) { create(:user) }
    context 'with autor questions' do
      before do
        sign_in question.user
        visit question_path(question)
      end

      scenario 'can see button "Best" answers' do
        expect(page).to have_content("Best")
      end

      scenario 'can made best answer' do
      end
    end

    context 'with no autor question' do
      scenario 'can\'t see button "Best" answers' do
        sign_in user
        visit question_path(question)
        expect(page).to_not have_content("Best")
      end
    end
  end

  describe 'Non autorization user' do
    scenario 'can\'t see button "Best" answers' do
      visit question_path(question)
      expect(page).to_not have_content("Best")
    end
  end
end