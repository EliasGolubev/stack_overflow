require 'rails_helper'

RSpec.describe AuthorNoticeJob, type: :job do
  include ActiveJob::TestHelper

  let(:users){ create_list(:user, 2) }
  let(:author){ users.first }
  let(:other){ users.last }
  let(:question){ create(:question, user: author) }
  let(:answer){ create(:answer, question: question, user: other) }

  it 'sends answer notice with author' do 
    expect(AnswerNoticeMailer).to receive(:answer_notice).with(answer).and_call_original
    AuthorNoticeJob.perform_now(answer)
  end
end
