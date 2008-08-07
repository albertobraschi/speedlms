require File.dirname(__FILE__) + '/../test_helper'

class OwnerWelcomeMailTest < ActionMailer::TestCase
  tests OwnerWelcomeMail
  #def test_sent
    #@expected.subject = 'OwnerWelcomeMail#sent'
    #@expected.body    = read_fixture('sent')
    #@expected.date    = Time.now

    #assert_equal @expected.encoded, OwnerWelcomeMail.create_sent(@expected.date).encoded
  #end

end
