require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:author){ create(:user) }
    let!(:question){ create(:question, user: author) }
    let!(:file){ create(:attachment, attachmentable: question) }
    let!(:user){ create(:user) }

    context 'with autor' do
      it 'can delete question file' do
        sign_in(author)
        expect { delete :destroy, id: file, format: :js }.to change(question.attachments, :count).by(-1)
      end
    end

    context 'with no autor' do
      it 'can\'t delete question file' do
        sign_in(user)
        expect { delete :destroy, id: file, format: :js }.to change(question.attachments, :count).by(0)
      end
    end
  end
end