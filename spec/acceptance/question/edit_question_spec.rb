require_relative '../acceptance_helper.rb'

feature 'User edit question', %q{
  In order to be able to edit my question text
  As an User
  I want to be able to edit my question
} do

  given(:question) { create(:question) }
  describe 'Autorization user' do

    context 'with autor question' do
      before do
        sign_in question.user
        visit question_path(question)
      end

      scenario 'can\'t see edit link at root path' do
        visit root_path

        expect(page).to_not have_content('Edit')
      end

      scenario 'can see link edit' do
        expect(page).to have_content('Edit')
      end

      scenario 'click link edit and can see edit form', js: true do
        click_on 'Edit'

        expect(page).to have_content('Title')
        expect(page).to have_content('Question text')
      end

      scenario 'can\'t see edit question form', js: true do
        expect(page).to_not have_content('Title')
        expect(page).to_not have_content('Question text')
        expect(page).to_not have_content('Edit question')
      end

      scenario 'edit question', js: true do
        click_on 'Edit'
        fill_in 'Title', with: 'New title question'
        fill_in_trix_editor("question_body_trix_input_question_#{question.id}", 'New body question')
        click_on 'Edit question'

        expect(page).to have_content('New title question')
        expect(page).to have_content('New body question')
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
      end

      scenario 'don\'t fill Title', js: true do
        click_on 'Edit'
        fill_in 'Title', with: nil
        fill_in_trix_editor("question_body_trix_input_question_#{question.id}", 'New body question')
        click_on 'Edit question'

        expect(page).to have_content('Title can\'t be blank')
      end

      scenario 'don\'t fill Question text', js: true do
        click_on 'Edit'
        fill_in 'Title', with: 'New title question'
        fill_in_trix_editor("question_body_trix_input_question_#{question.id}", nil)
        click_on 'Edit question'

        expect(page).to have_content('Body can\'t be blank')
      end

      scenario 'don\'t fill Title and Question text', js:true do
        click_on 'Edit'
        fill_in 'Title', with: nil
        fill_in_trix_editor("question_body_trix_input_question_#{question.id}", nil)
        click_on 'Edit question'

        expect(page).to have_content('Title can\'t be blank')
        expect(page).to have_content('Body can\'t be blank')
      end
    end

    context 'with no autor user' do
      scenario 'don\'t see edit link', js: true do
        user = create(:user)
        sign_in(user)
        visit question_path(question)

        expect(page).to_not have_content('Edit')
      end
    end
  end

  describe 'No autorizated user' do
    scenario 'don\'t see edit link', js: true do
      visit question_path(question)

      expect(page).to_not have_content('Edit')
    end
  end
end