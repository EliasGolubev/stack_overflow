require 'rails_helper'

RSpec.describe User, type: :model do
  it_behaves_like "Comentable"

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :username }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author' do 
    let(:question){ create :question }

    context 'with user is author' do 
      let(:user){ question.user }

      it 'return true' do 
        expect(user.author?(question)).to eq true
      end
    end

    context 'with user non author' do 
      let(:user){ create(:user) }

      it 'return false' do 
        expect(user.author?(question)).to eq false
      end
    end
  end

  describe '.find_for_oauth' do 
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'with user already has authorization' do 
      it 'returns this user' do 
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'with user has not authorization' do 
      context 'with user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do 
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do 
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do 
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do 
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
      context 'with user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { name: 'John Doe', email: 'new@user.com' }) }
        it 'creates new user' do 
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it 'returns new user' do 
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        it 'fills user email' do 
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'fills user username' do 
          user = User.find_for_oauth(auth)
          expect(user.username).to eq auth.info.name
        end

        it 'creates authorization for user' do 
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do 
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '.all_another_users' do 
    let!(:current_user) { create(:user) }
    let!(:users) { create_list(:user, 3) }

    it 'return all another users to current user' do 
      users_array = User.all_another_users(current_user)
      users.each do |user|
        expect(users_array).to include user
      end
      expect(users_array).to_not include current_user
    end
  end
end 