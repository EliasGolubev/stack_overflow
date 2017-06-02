require_relative '../acceptance_helper.rb'

feature 'user can search questions, answers, comments' do 
  given!(:first_question) { create(:question, title: 'First question text') }
  given!(:second_question) { create(:question, title: 'Second question text') }
  given!(:first_answer) { create(:answer, body: 'First answer text', question: first_question) }
  given!(:second_answer) { create(:answer, body: 'Second answer text', question: second_question) }
  given!(:first_comment) { create(:comment, body: 'First comment text', commentable: first_question) }
  given!(:second_comment) { create(:comment, body: 'Second comment text', commentable: second_answer) }
  given!(:find_user){ create(:user, email: 'text@user.rb') }
  
  background do
    index
    visit root_path
  end

  context 'with non result search' do 
    scenario 'user search with empty query', js: true do
      click_button 'Find'

      expect(page).to have_content('Not found')
    end

    scenario 'user search with all search', js: true do
      fill_in 'query', with: 'zczxc'
      click_on 'Find'

      expect(page).to have_content('Not found')
    end

    scenario 'user search with questions', js: true do
      fill_in 'query', with: 'zxzcx'
      select 'Questions', from: 'resourse'
      click_on 'Find'

      expect(page).to have_content 'Not found'
    end

    scenario 'user search with answers', js: true do
      fill_in 'query', with: 'zxzcx'
      select 'Answers', from: 'resourse'
      click_on 'Find'

      expect(page).to have_content 'Not found'
    end

    scenario 'user search with comments', js: true do
      fill_in 'query', with: 'zxzcx'
      select 'Comments', from: 'resourse'
      click_on 'Find'

      expect(page).to have_content 'Not found'
    end

    scenario 'user search with user', js: true do
      fill_in 'query', with: 'zxzcx'
      select 'Users', from: 'resourse'
      click_on 'Find'

      expect(page).to have_content 'Not found'
    end
  end

  context 'with result search' do
    scenario 'user all search', js: true do
      fill_in 'query', with: 'text'
      select 'All', from: 'resourse'
      click_on 'Find'

      expect(page).to have_content first_question.title
      expect(page).to have_content first_question.body
      expect(page).to have_content second_question.title
      expect(page).to have_content second_question.body
      expect(page).to have_content first_answer.body
      expect(page).to have_content second_answer.body
      expect(page).to have_content first_comment.body
      expect(page).to have_content second_comment.body
      expect(page).to have_content find_user.email
    end

    scenario 'user questions search', js: true do
      fill_in 'query', with: 'text'
      select 'Questions', from: 'resourse'
      click_on 'Find'

      expect(page).to have_content first_question.title
      expect(page).to have_content first_question.body
      expect(page).to have_content second_question.title
      expect(page).to have_content second_question.body
      expect(page).to_not have_content first_answer.body
      expect(page).to_not have_content second_answer.body
      expect(page).to_not have_content first_comment.body
      expect(page).to_not have_content second_comment.body
      expect(page).to_not have_content find_user.email
    end

    scenario 'user search first question select Questions', js: true do
      fill_in 'query', with: 'First'
      select 'Questions', from: 'resourse'
      click_on 'Find'

      expect(page).to have_content first_question.title
      expect(page).to_not have_content second_question.title
    end

    scenario 'user search answer', js: true do
      fill_in 'query', with: 'text'
      select 'Answers', from: 'resourse'
      click_on 'Find'

      expect(page).to have_content first_question.title
      expect(page).to_not have_content first_question.body
      expect(page).to have_content second_question.title
      expect(page).to_not have_content second_question.body
      expect(page).to have_content first_answer.body
      expect(page).to have_content second_answer.body
      expect(page).to_not have_content first_comment.body
      expect(page).to_not have_content second_comment.body
      expect(page).to_not have_content find_user.email
    end

    scenario 'user search comment', js: true do
      fill_in 'query', with: 'text'
      select 'Comments', from: 'resourse'
      click_on 'Find'

      expect(page).to have_content first_question.title
      expect(page).to_not have_content first_question.body
      expect(page).to have_content second_question.title
      expect(page).to_not have_content second_question.body
      expect(page).to_not have_content first_answer.body
      expect(page).to_not have_content second_answer.body
      expect(page).to have_content first_comment.body
      expect(page).to have_content second_comment.body
      expect(page).to_not have_content find_user.email
    end

    scenario 'user search users', js: true do
      fill_in 'query', with: 'text'
      select 'Users', from: 'resourse'
      click_on 'Find'

      expect(page).to_not have_content first_question.title
      expect(page).to_not have_content first_question.body
      expect(page).to_not have_content second_question.title
      expect(page).to_not have_content second_question.body
      expect(page).to_not have_content first_answer.body
      expect(page).to_not have_content second_answer.body
      expect(page).to_not have_content first_comment.body
      expect(page).to_not have_content second_comment.body
      expect(page).to have_content find_user.email
    end
  end
end
