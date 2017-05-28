class Question < ApplicationRecord
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachmentable
  has_many :comments, dependent: :destroy, as: :commentable, inverse_of: :commentable
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  after_create :subscribe_author

  def subscribe?(user)
    subscriptions.where(user_id: user.id).present?
  end

  def subscription(user)
    subscriptions.where(user_id: user.id).first
  end

  private 

  def subscribe_author
    subscriptions.create(user_id: user.id)
  end
end
