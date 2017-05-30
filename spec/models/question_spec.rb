require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like "votable"
  it_behaves_like "Comentable"
  it_behaves_like "Attachmentable"

  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  describe '#subscribe_author' do 
    let(:user) { create (:user) }
    let(:question) { build(:question, user: user) }

    it 'perform after question has been created' do 
      expect(question).to receive(:subscribe_author)
      question.save
    end

    it 'subscribe author question after create' do 
      expect { question.save }.to change(user.subscriptions, :count).by(1)
    end
  end
end
