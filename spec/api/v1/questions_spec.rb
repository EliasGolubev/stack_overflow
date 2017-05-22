require 'rails_helper'

describe 'Questions API' do 
  describe 'GET /index' do 
    context 'unauthorized' do 
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do 
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status code' do 
        expect(response).to be_success
      end

      it 'returns list of questions' do 
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      it 'returns questions with valid json schema attributes' do 
        expect(response).to match_response_schema("questions")
      end
    end
  end

  describe 'GET /show' do 
    let!(:question) { create(:question) } 
    context 'unauthorized' do
      
      it 'returns 401 status if there is no access_token' do 
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do 
        get "/api/v1/questions/#{question.id}", access_token: '123', format: :json
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do 
      let(:access_token) { create(:access_token) }
      
      let!(:question) { create(:question) }
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let!(:attachments) { create_list(:attachment, 2, attachmentable: question) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do 
        expect(response).to be_success
      end

      it 'returns size question' do 
        expect(response.body).to have_json_size(1)
      end

      it 'returns question with valid json schema attributes' do 
        expect(response).to match_response_schema("question")
      end

      it 'returns comment question' do 
        expect(response.body).to have_json_size(2).at_path('question/comments/')
      end

      it 'returns attachment question' do 
        expect(response.body).to have_json_size(2).at_path('question/attachments/')
      end

      it 'attachment contains a file url' do
        expect(response.body).to be_json_eql(attachments.first.file.url.to_json).at_path("question/attachments/1/file_url")
      end
    end
  end

  describe 'POST /create' do 
    context 'unauthorized' do 
      it 'returns 401 status if there is no access_token' do 
        post "/api/v1/questions/", question: attributes_for(:question), format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do 
        post "/api/v1/questions/", question: attributes_for(:question), access_token: '123', format: :json
        expect(response.status).to eq 401
      end

      it 'does not save answer in database with no access_token' do
        expect{ post "/api/v1/questions/", question: attributes_for(:question), format: :json }.not_to change(Question, :count)
      end

      it 'does not save answer in database with invalid access_token' do
        expect{ post "/api/v1/questions/", question: attributes_for(:question), access_token: '123', format: :json }.not_to change(Question, :count)
      end
    end

    context 'authorized' do 
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with invalid attributes' do 
        it 'returns 422 status' do 
          post "/api/v1/questions", question: attributes_for(:invalid_question), access_token: access_token.token, format: :json
          expect(response.status).to eq 422
        end

        it 'does not save question in database' do 
          expect{ post "/api/v1/questions", question: attributes_for(:invalid_question), access_token: access_token.token, format: :json }.not_to change(Question, :count)
        end
      end

      context 'with valid attributes' do 
        it 'returns 200 status code' do 
          post "/api/v1/questions", question: attributes_for(:question), access_token: access_token.token, format: :json
          expect(response).to be_success
        end

        it 'save question in database' do
          expect{ post "/api/v1/questions", question: attributes_for(:question), access_token: access_token.token, format: :json }.to change(Question, :count).by(1)
        end
      end
    end
  end
end