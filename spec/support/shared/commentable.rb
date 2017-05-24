require 'rails_helper'

shared_examples_for "Comentable" do 
  it { should have_many(:comments).dependent(:destroy) }
end