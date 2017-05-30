require 'rails_helper'

shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  it 'return rating' do
    expect(question.rating).to eq(0)
  end

  it 'user vote positive' do
    question.positive(user)

    expect(question.rating).to eq(1)
  end

  it 'user vote negative' do
    question.negative(user)

    expect(question.rating).to eq(-1)
  end
end