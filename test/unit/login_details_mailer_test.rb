require File.dirname(__FILE__) + '/../test_helper'

class LoginDetailsMailerTest < ActionMailer::TestCase
  tests LoginDetailsMailer
  #def test_sent
    #@expected.subject = 'LoginDetailsMailer#sent'
    #@expected.body    = read_fixture('sent')
    #@expected.date    = Time.now

    #assert_equal @expected.encoded, LoginDetailsMailer.create_sent(@expected.date).encoded
  #end

end
