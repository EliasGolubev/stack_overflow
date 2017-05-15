require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do 
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, user: user }
    let(:other_question) { create :question, user: other }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Attachment }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other), user: user }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other), user: user }

    it { should be_able_to :update, create(:comment, user: user), user: user }
    it { should_not be_able_to :update, create(:comment, user: other), user: user }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other), user: user }

    it { should be_able_to :destroy, create(:answer, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other), user: user }

    it { should be_able_to :destroy, create(:attachment, attachmentable: question), user: user }
    it { should_not be_able_to :destroy, create(:attachment, attachmentable: other_question), user: other }

    it { should be_able_to :set_best, create(:answer, question: question) }
    it { should_not be_able_to :set_best, create(:answer, question: other_question) }

    it { should be_able_to :vote, create(:question, user: other) }
    it { should be_able_to :vote, create(:answer, user: other) }

    it { should_not be_able_to :vote, create(:question, user: user) }
    it { should_not be_able_to :vote, create(:answer, user: user) }
  end
end