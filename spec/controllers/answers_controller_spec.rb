require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  
  let(:question){ create(:question) }
  let(:answer){ create(:answer, question: question) }
 
  describe 'GET #new' do
    before { get :new, question_id: question }
    
    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end 

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do 
    before { get :edit, id: answer }

    it 'assings the requsted answer to @answer' do 
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do 
      expect(response).to render_template :edit
    end
  end

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

      it 're-renders new view' do 
        post :create, answer: attributes_for(:invalid_answer), question_id: question

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do 
    context 'with valid answer' do 
      it 'assings the requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer)

        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer atributes' do 
        patch :update, id: answer, answer: { body: 'new body' }

        answer.reload

        expect(answer.body).to eq 'new body'
      end
    end

    context 'with invalid answer' do 
      before do 
        patch :update, id: answer, answer: { body: nil }
      end
      
      it 'does\'t change answer attributes' do
        expect(answer.body).to eq 'MyText'
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
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
