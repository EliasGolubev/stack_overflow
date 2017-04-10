require 'rails_helper'
require_relative 'concerns/votable_spec'

RSpec.describe Question, type: :model do
  it_behaves_like "votable"

  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }
end
