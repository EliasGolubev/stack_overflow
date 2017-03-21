require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question){ create(:question) }
  let(:answer){ create(:answer, question: question) }
  let(:user){ answer.user }
  let(:another_user) { create(:user) }

  describe 'POST #create' do 
    sign_in_user
    
    context 'with valid answer' do 
      it 'save new answer at database' do
        expect{ post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render create tamplate' do 
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template 'answers/create'
      end
    end

    context 'with invalid answer' do 
      it 'don\'t save question in the database' do 
        expect{ post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders question show view' do 
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js

        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }
    context 'current user is author questions' do 
      before { sign_in(user)}
      
      it 'deletes answer' do 
        expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
      end

      it 'redirect to show question view' do
        delete :destroy, id: answer
        expect(response).to redirect_to question
      end
    end

    context 'current user is not author questions' do 
      before { sign_in(another_user)}
      
      it 'don\'t delete answer' do
        expect { delete :destroy, id: answer }.to change(Answer, :count).by(0)
      end

      it 'redirect to question view' do 
        delete :destroy, id: answer
        expect(response).to redirect_to question
      end
    end
  end
end
