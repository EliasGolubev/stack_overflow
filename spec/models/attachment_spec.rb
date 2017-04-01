require 'rails_helper'

RSpec.describe Attachment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { should belong_to :attachmentable }

  describe 'return polymorphic resource' do
    context 'with question resource' do
      let(:question){ create(:question) }
      let(:file){ create(:attachment, attachmentable: question) }

      it 'return question object' do
        expect(file.getPolymorphicResource).to eq question
      end
    end

    context 'with answer resource' do
      let(:answer){ create(:answer) }
      let(:file){ create(:attachment, attachmentable: answer) }

      it 'return answer object' do
        expect(file.getPolymorphicResource).to eq answer
      end
    end
  end
end
