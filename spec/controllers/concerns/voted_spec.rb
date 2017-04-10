require 'rails_helper'

RSpec.shared_examples 'voted' do

  let!(:votable){ create(described_class.controller_name.classify.underscore.to_sym) }

  describe 'POST#positive_vote' do

    context 'with author question' do
      before { sign_in votable.user }

      it 'don\'t vote' do
        expect{ post :positive_vote, id: votable.id, format: :json }.to_not change(Vote, :count)
      end

      it 'renders json' do
        post :positive_vote, id: votable.id, format: :json

        expect(response.headers['Content-Type']).to match /json/
      end
    end

    context 'with logged user' do
      sign_in_user

      it 'assigns votable to @votable' do
        post :positive_vote, id: votable.id, format: :json

        expect(assigns(:votable)).to eq votable
      end

      it 'can vote' do
        expect{ post :positive_vote, id: votable.id, format: :json  }.to change(Vote, :count).by(1)
      end

      it 'can vote once' do
        post :positive_vote, id: votable.id, format: :json
        expect{ post :positive_vote, id: votable.id, format: :json  }.to change(Vote, :count).by(0)
      end

      it 'renders json' do
        post :positive_vote, id: votable.id, format: :json

        expect(response.headers['Content-Type']).to match /json/
      end
    end
    context 'with non logged user' do
      it 'don\'t vote' do
        expect{ post :positive_vote, id: votable.id, format: :json }.to_not change(Vote, :count)
      end

      it 'renders json' do
        post :positive_vote, id: votable.id, format: :json

        expect(response.headers['Content-Type']).to match /json/
      end
    end
  end

  describe 'POST#negative_vote' do
    context 'with author question' do
      before { sign_in votable.user }

      it 'don\'t vote' do
        expect{ post :negative_vote, id: votable.id, format: :json }.to_not change(Vote, :count)
      end

      it 'renders json' do
        post :negative_vote, id: votable.id, format: :json

        expect(response.headers['Content-Type']).to match /json/
      end
    end
    context 'with logged user' do
      sign_in_user

      it 'assigns votable to @votable' do
        post :negative_vote, id: votable.id, format: :json

        expect(assigns(:votable)).to eq votable
      end

      it 'can vote' do
        expect{ post :negative_vote, id: votable.id, format: :json  }.to change(Vote, :count).by(1)
      end

      it 'can vote once' do
        post :negative_vote, id: votable.id, format: :json

        expect{ post :negative_vote, id: votable.id, format: :json  }.to change(Vote, :count).by(0)
      end

      it 'renders json' do
        post :negative_vote, id: votable.id, format: :json

        expect(response.headers['Content-Type']).to match /json/
      end
    end
    context 'with non logged user' do

      it 'don\'t vote' do
        expect{ post :negative_vote, id: votable.id, format: :json }.to_not change(Vote, :count)
      end

      it 'renders json' do
        post :negative_vote, id: votable.id, format: :json

        expect(response.headers['Content-Type']).to match /json/
      end
    end
  end

  describe 'DELETE#re_vote' do
    let(:user){ create(:user) }

    subject(:create_vote) do
      sign_in user
      post :positive_vote, id: votable.id, format: :json
    end

    it 'can re-vote' do
      create_vote

      expect{ delete :re_vote, id: votable.id, format: :json }.to change(Vote, :count).by(-1)
    end

    it 'can re-vote once' do
      create_vote
      delete :re_vote, id: votable.id, format: :json

      expect{ delete :re_vote, id: votable.id, format: :json }.to_not change(Vote, :count)
    end

    it 'renders json' do
      create_vote
      delete :re_vote, id: votable.id, format: :json

      expect(response.headers['Content-Type']).to match /json/
    end
  end
end
