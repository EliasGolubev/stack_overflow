require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'Associations' do 
    it { should have_many :answers }
  end

  context 'Validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  context 'Collbacks' do 
    it 'delete a question deleted answers' do 
      question = Question.create(title: '123', body: '321')
      answer = Answer.create(body: '4321', question: question)
      question.destroy

      expect(Answer.all).not_to include answer 
    end 
  end
end
