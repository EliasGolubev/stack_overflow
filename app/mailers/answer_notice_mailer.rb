class AnswerNoticeMailer < ApplicationMailer
  def answer_notice(user, answer)
    @answer = answer
    @question = answer.question
    @user = answer.user
    @author = user

    mail(to: @author.email, subject: "New answer for #{@question.title}")
  end
end
