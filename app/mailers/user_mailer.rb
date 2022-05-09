class UserMailer < BaseMailer

  def send_verification_token_email(user_id, options={})
    @user = User.find(user_id)
    @options = options
    mail({
      :to => @user.email,
      :subject => ( @options[:confirmation] ? "Confirm your account" : "Verification code" )
    })
  end

end