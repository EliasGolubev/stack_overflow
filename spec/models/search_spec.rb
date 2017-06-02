require 'rails_helper'

RSpec.describe Search do 
  describe '.search' do
    let(:text){ 'Testing request text' }
    it 'find with all resourse' do
      expect(ThinkingSphinx).to receive(:search).with(text)
      Search.find(text, 'All')
    end

    it 'return nil with other resourse' do
      expect(Search.find(text, 'Other')).to be_nil
    end

    %w(Questions Answers Comments Users).each do |res|
      it "find with #{res} resourse" do
        expect(ThinkingSphinx).to receive(:search).with(text, classes: [res.singularize.classify.constantize])
        Search.find(text, res)
      end
    end
  end
end
