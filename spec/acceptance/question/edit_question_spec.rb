require_relative '../acceptance_helper.rb'

feature 'User edit question', %q{
  In order to be able to edit my question text
  As an User
  I want to be able to edit my question
} do 
  before do 
    @user = create(:user)
    @question = @user.questions.create(title: 'Text', body: 'Body text')
  end

  scenario 'User can see button edit(his question) on root_path' do 
    sign_in(@user)

    visit root_path
    click_on 'Edit'

    expect(current_path).to eq edit_question_path(@question)
    expect(page).to have_content('Title')
    expect(page).to have_content('Question text')
    expect(page).to have_button('Edit question')
  end

  scenario 'User can see button edit on his question path' do
    sign_in(@user)

    visit question_path(@question)

    expect(page).to have_content('Text')
    expect(page).to have_content('Edit')
  end

  scenario 'User can\'t see button edit(alien question) on root_path' do
    visit root_path

    expect(page).to have_content('Text')
    expect(page).to_not have_content('Edit')
  end

  scenario 'User can\'t see button edit on alien question path' do
    visit question_path(@question)

    expect(page).to have_content('Text')
    expect(page).to have_content('Body')
    expect(page).to_not have_content('Edit')
  end

  scenario 'User can edit his question' do 
    sign_in(@user)

    visit root_path
    click_on 'Edit'
    question_form(action: 'edit')

    expect(page).to have_content('Question title text')
    expect(page).to have_content('Question body text')
    expect(page).to_not have_content('Text')
    expect(page).to_not have_content('Body text')
  end

  scenario 'User edit his question and not fill title field' do 
    sign_in(@user)

    visit root_path
    click_on 'Edit'
    question_form(action: 'edit', title: nil)

    expect(page).to have_content('Title can\'t be blank')
  end

  scenario 'User edit his question and not fill title field' do 
    sign_in(@user)

    visit root_path
    click_on 'Edit'
    question_form(action: 'edit', body: nil)

    expect(page).to have_content('Body can\'t be blank')
  end

 
end