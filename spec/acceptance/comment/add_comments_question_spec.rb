require_relative '../acceptance_helper.rb'

feature 'Add comments to question', %q{
  In order to comments question
  As a autorizated user
  I'd like to be able to comments
} do
  given(:question){ create(:question) }
  given(:user){ create(:user) }

  before do 
    sign_in(user)
    visit question_path(question)
  end

  scenario 'create valid question comments', js: true do 
    
    fill_in "commentable-text-form-#{question.id}", with: 'Test text comments'
    click_on 'Create Comment'

    expect(page).to have_content('Test text comments')
  end

  scenario 'create no valid question comments', js: true do 

    fill_in "commentable-text-form-#{question.id}", with: nil
    click_on "Create Comment"

    expect(page).to have_content("Body can't be blank")
  end

  context "mulitple sessions" do
    scenario "comments appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do 
        fill_in "commentable-text-form-#{question.id}", with: 'Test text comments'
        click_on 'Create Comment'

        expect(page).to have_content('Test text comments')
      end

      Capybara.using_session('guest') do
        expect(page).to have_content('Test text comments')
      end
    end
  end
end