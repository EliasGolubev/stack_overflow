require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  
  let(:user){ create(:user) }
  let(:question){ create(:question) }
  let(:answer){ create(:answer, question: question) }

  describe 'POST #create' do 
    context 'with valid answer' do 
      it 'save new answer at database' do
        expect{ post :create, answer: attributes_for(:answer), question_id: question }.to change(Answer, :count).by(1)
      end

      it 'redirect to question path' do 
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question
      end
    end

    context 'with invalid answer' do 
      it 'don\'t save question in the database' do 
        expect{ post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Answer, :count)
      end

      it 're-renders question show view' do 
        post :create, answer: attributes_for(:invalid_answer), question_id: question

        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    it 'deletes answer' do 
      expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end

    it 'redirect to show question view' do
      delete :destroy, id: answer
      expect(response).to redirect_to question
    end
  end
end
