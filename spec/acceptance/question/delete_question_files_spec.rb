require_relative '../acceptance_helper.rb'

feature 'Delete files to question', %q{
  In order to destroy files with question
  As an question's author
  I'd like to be able to delete files
} do

  describe 'Log in user delete file' do
    given!(:author){ create(:user) }
    given!(:question){ create(:question, user: author) }
    given!(:file){ create(:attachment, attachmentable: question) }
    given(:user){ create(:user) }

    context 'with autor question' do

      before do
        sign_in author
        visit question_path(question)
      end

      scenario 'can see delete link with question file', js: true do
        within ".attachments-question-files" do
          expect(page).to have_content('testing_file.txt')
          expect(page).to have_content('Delete')
        end
      end

      scenario 'can delete file', js: true do
        within ".attachments-question-files" do
          click_on 'Delete'
          expect(page).to_not have_content('testing_file.txt')
          expect(page).to_not have_content('Delete')
        end
      end
    end

    context 'with non autor question' do
      before do
        sign_in user
        visit question_path(question)
      end
      scenario 'can\'t see delete link with question file' do
        within ".attachments-question-files" do
          expect(page).to have_content('testing_file.txt')
          expect(page).to_not have_content('Delete')
        end
      end
    end
  end

  describe 'Non log in user delete file' do
    given!(:question){ create(:question) }
    given!(:file){ create(:attachment, attachmentable: question) }

    scenario 'can\'t see delete link with question file' do
      visit question_path(question)
      within ".attachments-question-files" do
        expect(page).to have_content('testing_file.txt')
        expect(page).to_not have_content('Delete')
      end
    end
  end
end