class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :attachments, dependent: :destroy, as: :attachmentable

  validates :body, :question_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  default_scope -> { order("best DESC") }

  def set_best
    transaction do
      Answer.where(question_id: question.id, best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
