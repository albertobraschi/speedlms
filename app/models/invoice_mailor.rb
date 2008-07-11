class InvoiceMailor < ActionMailer::Base


  #sends confirmation email to buyer for his invoice.
  def confirmation(invoice)
    @subject    = '[SpeedLMS] Confirmation of Payment'
    @recipients = [invoice.user.email, 'admin@speedlms.com']
    @from       = 'system@speedlms.com'
    @sent_on    = Time.now
    @body["invoice"] = invoice
    @body["user"] = invoice.user
    @body['plan'] = invoice.signup_plan
    @headers = {}
  end
end
