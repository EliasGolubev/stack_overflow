shared_examples_for "API /index Authenticable" do 
  context 'authorized' do 

    before { do_request(access_token: access_token.token) }

    it 'returns 200 status code' do 
      expect(response).to be_success
    end

    it "returns list" do 
      expect(response.body).to have_json_size(2).at_path(api_path)
    end

    it "returns with valid json schema attributes" do 
      expect(response).to match_response_schema(api_path)
    end
  end
end