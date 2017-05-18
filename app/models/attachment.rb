class Attachment < ApplicationRecord
  belongs_to :attachmentable, optional: true, polymorphic: true

  mount_uploader :file, FileUploader

  def with_meta
    Hash['filename', file.filename, 'url', file.url]
  end
end
