require 'rails_helper'

describe 'Questions API' do 
  describe 'GET /index' do 
    let(:access_token)  { create(:access_token) }
    let(:api_path)      { 'questions' }
    let!(:questions)    { create_list(:question, 2) }
    let(:question)      { questions.first }
    let!(:answer)       { create(:answer, question: question) }
    
    it_behaves_like "API Authenticable"
    it_behaves_like "API /index Authenticable"

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do 
    let(:access_token)    { create(:access_token) }
    let(:api_path)        { "question" }
    let!(:question)       { create(:question) } 
    let!(:comments)       { create_list(:comment, 2, commentable: question) }
    let!(:attachments)    { create_list(:attachment, 2, attachmentable: question) }

    it_behaves_like "API Authenticable"
    it_behaves_like "API /show Authenticable"

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do 
    let!(:user)           { create(:user) }
    let(:access_token)    { create(:access_token, resource_owner_id: user.id) }
    let(:expected_class)  { Question }

    it_behaves_like "API Authenticable"
    it_behaves_like "API /create Authenticable"

    def do_request(options = {})
      post "/api/v1/questions/", { question: attributes_for(:question), format: :json }.merge(options)
    end

    def do_invalid_attributes_request(options = {})
      post "/api/v1/questions/", { question: attributes_for(:invalid_question), format: :json }.merge(options)
    end
  end
end