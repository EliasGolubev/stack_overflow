class DailyDigestMailer < ApplicationMailer
  def daily_digest(user, resources)
    @user = user
    @resources = resources

    mail(to: @user.email, subject: "Daily digest")
  end
end
