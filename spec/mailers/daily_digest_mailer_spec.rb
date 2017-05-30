require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  let(:users) { create_list(:user, 2) }
  let(:questions) { create_list(:question, 2, created_at: yesturday_time) }
  let(:mail) { DailyDigestMailer.daily_digest(users.first).deliver_now } 

  it 'renders the subject' do 
    expect(mail.subject).to eq('Daily digest')
  end

  it 'renders the receiver email' do 
    expect(mail.to.join(' ')).to eq(users.first.email)
  end

  it 'mail have user name' do 
    expect(mail).to have_content users.first.username
  end 

  it 'have link with question' do
    questions.each do |question| 
      expect(mail).to have_link question.title
    end 
  end

  def yesturday_time
    Time.current.midnight - 1.hour
  end
end
