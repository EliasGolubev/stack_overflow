require 'rails_helper'

RSpec.describe Attachment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { should belong_to :attachmentable }
end
