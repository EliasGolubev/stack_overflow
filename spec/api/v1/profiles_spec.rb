require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
       
    it_behaves_like "API Authenticable"

    context 'authorized' do 
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }
      
      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns current user with valid json schema attributes' do 
        expect(response).to match_response_schema("user")
      end
    end
    
    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET /list' do 
    
    it_behaves_like "API Authenticable"

    context 'authorized' do 
      let(:me) { create(:user) }
      let!(:other_users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/list', format: :json, access_token: access_token.token }

      it 'returns 200 status' do 
        expect(response).to be_success
      end

      it 'returns users with valid json schema attributes' do 
        expect(response).to match_response_array_schema("user")
      end
    end
    
    def do_request(options = {})
      get '/api/v1/profiles/list', { format: :json }.merge(options)
    end
  end
end
