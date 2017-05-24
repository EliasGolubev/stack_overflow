require 'rails_helper'
require_relative 'concerns/votable_spec'

RSpec.describe Answer, type: :model do
  it_behaves_like "votable"
  it_behaves_like "Comentable"
  it_behaves_like "Attachmentable"

  it { should belong_to :question }
  it { should belong_to :user }
  
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }

  it { should accept_nested_attributes_for :attachments }

  describe 'Best answer' do
    let(:question){ create(:question) }
    let(:answer1) { create(:answer, question: question) }
    let(:answer2) { create(:answer, question: question) }

    it 'set best' do
      answer1.set_best

      expect(answer1.best).to eq true
      expect(answer2.best).to eq false
    end

    it 'reset best' do
      answer1.set_best
      answer2.set_best
      answer1.reload
      answer2.reload

      expect(answer1.best).to eq false
      expect(answer2.best).to eq true
    end
  end
end
