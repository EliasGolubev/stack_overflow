require 'rails_helper'

describe 'Answers API' do 
  describe 'GET /answers' do 
    let(:access_token)  { create(:access_token) }
    let(:api_path)      { 'answers' }
    let!(:question)     { create(:question) }
    let!(:answer)       { create_list(:answer, 2, question_id: question.id) }
    
    it_behaves_like "API Authenticable"
    it_behaves_like "API /index Authenticable"

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do 
    let(:user)            { create(:user) }
    let(:access_token)    { create(:access_token, resource_owner_id: user.id) }
    let(:api_path)        { "answer" }
    let!(:question)       { create(:question) }
    let!(:answer)         { create(:answer, question_id: question.id) }
    let!(:comments)       { create_list(:comment, 2, commentable: answer) }
    let!(:attachments)    { create_list(:attachment, 2, attachmentable: answer) }

    it_behaves_like "API Authenticable"    
    it_behaves_like "API /show Authenticable"    

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do 
    let!(:question)       { create(:question) }
    let(:user)            { create(:user) }
    let(:access_token)    { create(:access_token, resource_owner_id: user.id) }
    let(:expected_class)  { Answer }

    it_behaves_like "API Authenticable"
    it_behaves_like "API /create Authenticable"

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers/", { answer: attributes_for(:answer), format: :json }.merge(options)
    end

    def do_invalid_attributes_request(options = {})
      post "/api/v1/questions/#{question.id}/answers/", { answer: attributes_for(:invalid_answer), format: :json }.merge(options)
    end
  end
end
