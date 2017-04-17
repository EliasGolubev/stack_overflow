class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, optional: true, polymorphic: true
end