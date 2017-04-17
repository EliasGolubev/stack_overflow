require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :username }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'author' do 
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
end 