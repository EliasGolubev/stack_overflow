require_relative '../acceptance_helper.rb'

feature 'Daily digest' do 
  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 2, created_at: 1.days.ago) }
  given(:old_question) { create(:question, title: 'Old question', created_at: 2.days.ago) }

  background do
    user
    questions
    old_question

    DailyDigestJob.perform_now
    open_email(user.email)
  end

  scenario "user can see new question title link" do
    expect(current_email).to have_link questions.first.title
    expect(current_email).to have_link questions.last.title
  end

  scenario 'user can\'t see old question title link' do 
    expect(current_email).to_not have_link old_question.title
  end
end