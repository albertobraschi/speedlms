class Invoice < ActiveRecord::Base
  belongs_to :user 
  belongs_to :signup_plan
  
  def confirm
    self.update_attribute('status','confirmed')
  end
end
