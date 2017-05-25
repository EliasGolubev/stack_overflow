class AnswerNoticeMailer < ApplicationMailer
  def answer_notice(answer)
    @answer = answer
    @question = answer.question
    @user = answer.user
    @author = @question.user

    mail(to: @author.email, subject: "New answer fo #{@question.title}")
  end
end
