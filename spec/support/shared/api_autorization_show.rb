shared_examples_for "API /show Authenticable" do 
  context 'authorized' do 
    
    before { do_request(access_token: access_token.token) }

    it 'returns 200 status code' do 
      expect(response).to be_success
    end

    it 'returns size' do 
      expect(response.body).to have_json_size(1)
    end

    it 'returns with valid json schema attributes' do 
      expect(response).to match_response_schema(api_path)
    end

    it 'returns comment' do 
      expect(response.body).to have_json_size(2).at_path("#{api_path}/comments")
    end

    it 'returns attachment' do 
      expect(response.body).to have_json_size(2).at_path("#{api_path}/attachments")
    end

    it 'attachment contains a file url' do
      expect(response.body).to be_json_eql(attachments.first.file.url.to_json).at_path("#{api_path}/attachments/1/file_url")
    end
  end
end