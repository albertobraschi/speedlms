class ConfirmMailer < ActionMailer::Base
  def sent(user, url)
    @subject    = 'ConfirmMailer#sent'
    @recipients = '#{user.email}'
    @from       = 'system@speedlms.com'
    @sent_on    = Time.now
    @body["user"] = user
    @body["link"] = url
    @headers = {}
  end
end
