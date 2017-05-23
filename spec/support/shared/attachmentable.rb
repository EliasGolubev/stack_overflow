require 'rails_helper'

shared_examples_for "Attachmentable" do 
  it { should have_many(:attachments).dependent(:destroy) }
end