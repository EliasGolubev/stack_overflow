class AuthorNoticeJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.includes(:user).find_each do |subscription|
      AnswerNoticeMailer.answer_notice(subscription.user, answer).deliver_later if answer.user_id != subscription.user_id
    end
  end
end
