class LoginDetailsMailer < ActionMailer::Base

  def sent(user)
    @subject    = 'LoginDetails'
	@body["user"]       = user
    @recipients = user.email
    @from       = 'system@speedlms.com'
    @sent_on    = Time.now
    @headers    = {}
  end
end
