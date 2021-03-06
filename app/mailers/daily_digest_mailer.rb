class DailyDigestMailer < ApplicationMailer
  def daily_digest(user)
    @user = user
    @questions = Question.where(created_at: 1.day.ago.all_day)

    mail(to: @user.email, subject: "Daily digest")
  end
end
