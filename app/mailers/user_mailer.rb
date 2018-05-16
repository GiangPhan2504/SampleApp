class UserMailer < ApplicationMailer

  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailers.account_activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mailers.password_reset")
  end
end
