class Question < ApplicationRecord
  has_many :answers

  validates :title, :body, presence: true

  after_destroy :destroy_answers

  private

  def destroy_answers
    answers.each(&:destroy)
  end
end
