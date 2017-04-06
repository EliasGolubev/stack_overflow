require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:question) { create(:question) }
  let!(:author) { question.user }
  let(:user) { create(:user) }
  let!(:vote) { create :vote }

  describe 'POST #create' do
    context 'with autor question' do
      before { sign_in(author) }

      it 'don\'t save new vote in database' do
        expect { post :create, vote: attributes_for(:vote), question_id: question }.to change(question.votes, :count).by(0)
      end
    end

    context 'with non autor question' do
      sign_in_user

      it 'save new vote in database' do
        expect { post :create, vote: attributes_for(:vote), question_id: question }.to change(question.votes, :count).by(1)
      end
    end

    context 'with sign out user' do
      it 'don\'t save new vote in database' do
        expect { post :create, vote: attributes_for(:vote), question_id: question }.to change(question.votes, :count).by(0)
      end
    end

  end

  describe 'PATCH #update' do

    context 'with users vote' do
      before { sign_in(vote.user) }

      it 'assings the requested vote to @vote' do
        patch :update, id: vote, vote: attributes_for(:vote)

        expect(assigns(:vote)).to eq vote
      end

      it 'change vote attributes' do
        patch :update, id: vote, vote: { vote: true }
        vote.reload

        expect(vote.vote).to eq true
      end
    end

    context 'with non users vote' do
      sign_in_user
      it 'don\'t change vote attributes' do
        patch :update, id: vote, vote: { vote: true }
        vote.reload

        expect(vote.vote).to_not eq true
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'with users vote' do
      before { sign_in(vote.user) }

      it 'deletes vote' do
        expect { delete :destroy, id: vote }.to change(Vote, :count).by(-1)
      end
    end

    context 'with non users vote' do
      sign_in_user

      it 'deletes vote' do
        expect { delete :destroy, id: vote }.to change(Vote, :count).by(0)
      end
    end
  end
  end