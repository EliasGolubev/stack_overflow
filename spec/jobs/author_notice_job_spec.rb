require 'rails_helper'

RSpec.describe AuthorNoticeJob, type: :job do
  include ActiveJob::TestHelper
  
  let!(:question){ create(:question) }
  let!(:subscription){ create_list(:subscription, 2, question: question) }
  let!(:answer){ create(:answer, question: question) }

  it 'sends answer notice with subscription user' do 
    answer.question.subscriptions.each do |subscription|
      expect(AnswerNoticeMailer).to receive(:answer_notice).with(subscription.user, answer).and_call_original
    end
    AuthorNoticeJob.perform_now(answer)
  end
end
