class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, presence: true

  default_scope -> { order("best DESC") }

  def set_best
    Answer.where(question_id: question.id, best: true).update_all(best: false)
    update(best: true)
  end
end
