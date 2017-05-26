class AuthorNoticeJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerNoticeMailer.answer_notice(answer).deliver_later
  end
end
