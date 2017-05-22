require 'rails_helper'

describe 'Answers API' do 
  describe 'GET /answers' do 
    context 'unauthorize' do 
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question_id: question.id) }
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorizate' do 
      let(:access_token) { create(:access_token) }

      let!(:question) { create(:question) }
      let!(:answer) { create_list(:answer, 2, question_id: question.id) }
      
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status' do 
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      it 'returns answers with valid json schema attributes' do
        expect(response).to match_response_schema("answers")
      end
    end
  end

  describe 'GET /show' do 
    context 'unauthorize' do 
      let!(:answer){ create(:answer) }

      it 'returns 401 status is no access_token' do 
        get "/api/v1/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status is invalid' do 
        get "/api/v1/answers/#{answer.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorizate' do 
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question_id: question.id) }
      let!(:comments){ create_list(:comment, 2, commentable: answer) }
      let!(:attachments) { create_list(:attachment, 2, attachmentable: answer) }
      
      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do 
        expect(response).to be_success
      end

      it 'returns answer with valid json schema attributes' do 
        expect(response).to match_response_schema("answer")
      end

      it 'returns answer with inluded comments' do
        expect(response.body).to have_json_size(2).at_path("answer/comments/")
      end

      it 'returns answer with inluded attachments' do
        expect(response.body).to have_json_size(2).at_path("answer/attachments/")
      end

      it 'attachment contains a file url' do
        expect(response.body).to be_json_eql(attachments.first.file.url.to_json).at_path("answer/attachments/1/file_url")
      end
    end
  end

  describe 'POST /create' do 
    let!(:question) { create(:question) }
    context 'unauthorize' do 
      it 'returns 401 status is no access_token' do 
        post "/api/v1/questions/#{question.id}/answers/", answer: attributes_for(:answer), format: :json
        expect(response.status).to eq 401
      end

       it 'returns 401 status is invalid access_token' do
        post "/api/v1/questions/#{question.id}/answers/", answer: attributes_for(:answer), access_token: '1234', format: :json
        expect(response.status).to eq 401
      end

      it 'does not save answer in database with no access_token' do
        expect{ post "/api/v1/questions/#{question.id}/answers/", answer: attributes_for(:answer), format: :json }.not_to change(Answer, :count)
      end

      it 'does not save answer in database with invalid access_token' do
        expect{ post "/api/v1/questions/#{question.id}/answers/", answer: attributes_for(:answer), access_token: '1234', format: :json }.not_to change(Answer, :count)
      end
    end

    context 'authorizate' do 
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      
      it 'returns 200 status' do
        post "/api/v1/questions/#{question.id}/answers/", answer: attributes_for(:answer), access_token: access_token.token, format: :json
        expect(response).to be_success
      end

      context 'with invalid attributes' do 
        it 'returns 422 status' do
          post "/api/v1/questions/#{question.id}/answers/", answer: attributes_for(:invalid_answer), access_token: access_token.token, format: :json
          expect(response.status).to eq 422
        end

        it 'does not save answer in database' do
          expect{ post "/api/v1/questions/#{question.id}/answers/", answer: attributes_for(:invalid_answer), access_token: access_token.token, format: :json }.not_to change(Answer, :count)
        end
      end

      context 'with valid attributes' do 
        it 'returns 200 status code' do 
          post "/api/v1/questions/#{question.id}/answers/", answer: attributes_for(:answer), access_token: access_token.token, format: :json
          expect(response).to be_success
        end

        it 'save answer in database' do
          expect{ post "/api/v1/questions/#{question.id}/answers/", answer: attributes_for(:answer), access_token: access_token.token, format: :json }.to change(Answer, :count).by(1)
        end
      end
    end
  end
end
