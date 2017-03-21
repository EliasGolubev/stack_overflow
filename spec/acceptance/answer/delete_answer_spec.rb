require 'rails_helper'

feature 'Destroy answer', %q{
  In order to delete answer
  As an authenticated user
  I have to click on the delete button
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Sign in user delete his question', js: true do 
    sign_in(user)

    visit question_path(question)
    fill_in 'Ask Answer', with: 'answer text'
    click_on 'Ask'

    click_link 'Delete'

    expect(page).to_not have_content('answer text')
  end

  scenario 'Sign in user can\'t delete someone else\'s question', js: true do
    sign_in(user)
    
    visit(question_path(question))
    fill_in 'Ask Answer', with: 'answer text'
    click_on 'Ask'
    click_on 'Sign out'
    visit(question_path(question))

    expect(page).to have_content('answer text')
    expect(page).to_not have_content('Delete')
  end
end