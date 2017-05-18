require 'rails_helper'
# 13df80ad30360dc4d00533799d82e59b8fe31a12c329fc0ab8db69eeef945f14

# client_id=7db32dabcb37985e4bd538666ef6321189de9aecea849331105e46693d192ae2&
# client_secret=df9f002fa176f62c4b05d0d0b3396fe3540cd2f7637414e015596636f7a80704&
# code=ae3c1433e07c3dd566a99f2f8e8c52b8ef22300e58c92fc65fdbb5a27ec0731d&
# grant_type=authorization_code&redirect_uri=urn:ietf:wg:oauth:2.0:oob
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
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question obgect contains #{attr}" do 
          question = questions.first
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do 
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      context 'answers' do 
        it 'include in question object' do 
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do 
            question = questions.first
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end

      end
    end
  end
end