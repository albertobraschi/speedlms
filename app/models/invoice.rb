class Invoice < ActiveRecord::Base
  belongs_to :user 
  belongs_to :signup_plan
  
  #Updates status of an buyer's invoice to confirmed.
  def confirm
    self.update_attribute('status','confirmed')
  end
end
