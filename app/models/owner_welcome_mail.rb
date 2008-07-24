class OwnerWelcomeMail < ActionMailer::Base

	#Sends a notification on a newly registered Owner on his/her email id with login details.
  def sent(user)
    @subject    = 'Notifications'
    @body['user']       = user
    @recipients = user.email
    @from       = 'system@speedlms.com'
    @sent_on    = Time.now
    @headers    = {}
  end
end
