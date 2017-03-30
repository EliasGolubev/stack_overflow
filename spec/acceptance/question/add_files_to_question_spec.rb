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
  end

  scenario 'User adds file when asks question' do
    fill_in 'Title',          with: 'Test question'
    fill_in 'Question text',  with: 'Test text question'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Ask question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end