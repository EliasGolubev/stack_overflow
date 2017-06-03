require_relative '../acceptance_helper.rb'

feature 'Add files to question', %q{
  In order to ilustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path
    fill_in 'Title',          with: 'Test question'
    fill_in_trix_editor('question_body_trix_input_question', 'Test text question')
    click_on 'Add attachments'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  end

  scenario 'User adds file when asks question', js: true do
    click_on 'Ask question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User adds many files when asks question', js: true do
    click_on 'Add attachments'
    within  all('.nested-forms').last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Ask question'

    expect(page).to have_link  'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_content 'rails_helper.rb'
  end
end
