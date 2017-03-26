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
    end
  end

  describe 'PATCH #update' do 

    context 'with user is autor answer' do
      sign_in_user
      let(:answer){ create(:answer, question: question, user: @user) }

      it 'assings the requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer atributes' do
        patch :update, id: answer, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update tamplate' do
        patch :update, id: answer, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'with user is not autor answer' do
      sign_in_user
      let(:answer){ create(:answer, question: question) }

      it 'no changes answer atributes' do
        patch :update, id: answer, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    context 'current user is author questions' do
      before { sign_in(user)}
      
      it 'deletes answer' do 
        expect { delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'current user is not author questions' do 
      before { sign_in(another_user)}
      
      it 'don\'t delete answer' do
        expect { delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(0)
      end
    end
  end

  describe 'PATCH #set_best' do
    context 'with autor question set best' do
      sign_in_user
      let(:question){ create(:question, user: @user) }
      let(:answer){ create(:answer, question: question) }

      it 'change best answer' do
        patch :set_best, id: answer, format: :js
        answer.reload
        expect(answer.best).to_not eq false
        expect(answer.best).to eq true
      end
    end

    context 'with no autor question set best' do
      sign_in_user
      let(:question){ create(:question) }
      let(:answer){ create(:answer, question: question) }

      it 'don\'t change answer best' do
        patch :set_best, id: answer, format: :js
        answer.reload
        expect(answer.best).to_not eq true
        expect(answer.best).to eq false
      end
    end

    context 'with non login user' do
      let(:question){ create(:question) }
      let(:answer){ create(:answer, question: question) }

      it 'don\'t change answer best' do
        patch :set_best, id: answer, format: :js
        answer.reload
        expect(answer.best).to_not eq true
        expect(answer.best).to eq false
      end
    end
  end
end
