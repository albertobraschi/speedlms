class ConfirmMailer < ActionMailer::Base

  #Sent email to user who requested for "forgot password".
  def sent(user, url)
    @subject    = 'Resetting Password'
    @recipients = user.email
    @from       = 'system@speedlms.com'
    @sent_on    = Time.now
    @body["user"] = user
    @body["link"] = url
    @headers = {}
  end
end
