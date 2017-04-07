class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachmentable
  has_many :votes, dependent: :destroy, as: :votable

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
