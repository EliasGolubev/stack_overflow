require_relative '../acceptance_helper.rb'

feature 'Add file to answer', %q{
  In order to ilustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user){ create(:user) }
  given(:question){ create(:question) }
  background do
    sign_in(user)
    visit question_path(question)
    click_on 'Add attachments'
    fill_in 'Ask Answer', with: 'text answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  end

  scenario 'User adds file when ask answer', js: true do

    click_on 'Ask'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds many file when ask answer', js: true do
    click_on 'Add attachments'
    within  all('.nested-forms').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Ask'
    within '.answers' do
      expect(page).to have_link  'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_content 'rails_helper.rb'
    end
  end
end