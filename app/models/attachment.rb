class Attachment < ApplicationRecord
  belongs_to :attachmentable, optional: true, polymorphic: true

  mount_uploader :file, FileUploader

  def getPolymorphicResource
    attachmentable_type == "Question" ? Question.find(attachmentable_id) : Answer.find(attachmentable_id)
  end
end
