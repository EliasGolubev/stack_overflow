require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question){ create(:question) }
  let(:answer){ create(:answer, question: question) }
  let(:user){ answer.user }


  describe 'POST #create' do
    context 'with loggin user' do
      sign_in_user
      it 'save new comments in the database with valid attributes' do 
        expect { post :create, comment: attributes_for(:comment), commentable: 'question', question_id: question, format: :js }.to change(Comment, :count).by(1)
      end
    end
    context 'with non loggin user' do 
      it 'can\'t save new comments in the database' do 
        expect { post :create, comment: attributes_for(:comment), question_id: question, format: :js }.to_not change(Comment, :count)
      end
    end
  end

  describe 'DELETE #destroy' do 
    
    context 'with author comments' do 
      sign_in_user
      let!(:comment){ create(:comment, user: @user) }
      it 'can delete comment' do 
        expect { delete :destroy, id: comment, format: :js }.to change(Comment, :count).by(-1)
      end
    end
    context 'with login user' do 
      sign_in_user
      let!(:comment){ create(:comment) }
      it 'can\'t delete comments' do
        expect { delete :destroy, id: comment, format: :js }.to_not change(Comment, :count)
      end
    end
    context 'with non login user' do 
      let!(:comment){ create(:comment) }
      it 'can\'t delete comments' do 
        expect { delete :destroy, id: comment, format: :js }.to_not change(Comment, :count)
      end
    end
  end
end