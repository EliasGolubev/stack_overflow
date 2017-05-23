shared_examples_for "API /create Authenticable" do
  context 'authorizate' do 
    it 'returns 200 status' do
      do_request(access_token: access_token.token)
      expect(response).to be_success
    end

    context 'with invalid attributes' do 
      it 'returns 422 status' do
        do_invalid_attributes_request(access_token: access_token.token)
        expect(response.status).to eq 422
      end

      it 'does not save answer in database' do
        expect{ do_invalid_attributes_request(access_token: access_token.token) }.not_to change(expected_class, :count)
      end
    end

    context 'with valid attributes' do 
      it 'returns 200 status code' do 
        do_request(access_token: access_token.token)
        expect(response).to be_success
      end

      it 'save answer in database' do
        expect{ do_request(access_token: access_token.token) }.to change(expected_class, :count).by(1)
      end
    end
  end
end