require "rails_helper"

RSpec.describe AnswerNoticeMailer, type: :mailer do
  let(:users){ create_list(:user, 2) }
  let(:question){ create(:question, user: users.first) }
  let(:answer) { create(:answer, user: users.last, question: question) }
  let(:mail) { AnswerNoticeMailer.answer_notice(users.first, answer).deliver_now } 

  it 'renders the subject' do 
    expect(mail.subject).to eq("New answer for #{question.title}")
  end

  it 'renders the receiver email' do 
    expect(mail.to.join(' ')).to eq(users.first.email)
  end

  it 'don\'t say another questions author mail' do 
    expect(mail.to.join(' ')).to_not eq(users.last.email)
  end

  it 'mail have create answer user name' do
    expect(mail).to have_content users.second.username
  end

  it 'have answer body' do 
    expect(mail).to have_content answer.body
  end

  it 'have link Go to question' do 
    expect(mail).to have_link "Go to question page"
  end
end
