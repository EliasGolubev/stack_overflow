require 'rails_helper'

feature 'User delete question', %q{
  In order to be able to delete my question
  As an User
  I want to be able to delete my question
}do 
  before do 
    @user = create(:user)
    @question = @user.questions.create(title: 'Text', body: 'Body text')
  end
  scenario 'User can delete his question' do 
    sign_in(@user)

    visit root_path
    click_on 'Delete'

    expect(page).to_not have_content('Text')
    expect(page).to_not have_content('Body text')
  end

  scenario 'User can\'t delete alien question' do
    visit root_path

    expect(page).to have_content('Text')
    expect(page).to_not have_content('Delete')
  end
end