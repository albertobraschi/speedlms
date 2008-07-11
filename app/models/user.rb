require 'digest/sha1'
class User < ActiveRecord::Base
	belongs_to :signup_plan
  ROLE = {:admin => "Admin", :owner => "Owner", :tutor => "Tutor", :student => "Student"}
  attr_accessor :password
	validates_presence_of     :firstname, :lastname
  validates_presence_of     :login, :email, 
  													:if => :not_openid?
  validates_presence_of     :signup_plan ,:speedlms_subdomain, :organisation, :timezone,
  													:if => Proc.new{ |a| a.role == ROLE[:owner] }, :message => "is must for Owner"
  validates_presence_of     :password, :password_confirmation, 
  													:if => :password_required? 
  validates_length_of       :password, :within => 4..40, 
  													:if => (:password_required? and Proc.new{|a| a.password.length > 0 if a.password})
  validates_confirmation_of :password,                   
  													:if => :password_required?
  validates_length_of       :login,    :within => 3..40, 
  													:if => (:not_openid? and Proc.new{ |a| a.login.length > 0 if a.login})
  validates_length_of       :email,    :within => 3..40, 
  													:if => (:not_openid? and Proc.new{|a| a.email.length > 0 if a.email}) 
  validates_format_of 			:email, :with =>%r{^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$}, 
                      			:if => Proc.new{|a| a.email.length > 0 if a.email}
  validates_format_of 			:logo, :with => %r{\.(gif|jpg|png)$}i, 
                      			:if => Proc.new{|a| a.logo.length > 0 if a.logo}
  validates_uniqueness_of   :login, :email, :if => :not_openid?
  validates_uniqueness_of   :speedlms_subdomain, :if => Proc.new{ |a| a.role == ROLE[:owner] }, :message => "is must for Owner"
                      			                   
  before_save 							:encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :pcode, :role, :plan, :signup_plan_id, :timezone, :logo, :lastname, :firstname, 
  :organisation, :speedlms_subdomain
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil. 
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  # Returns the authenticated password encrypted
  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  #sets remember_token expiry time.
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end
  
  #destroys remember_token and its expiry time
  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  #makes speedlms url for an owner after he signs up.
	def	speedlms_url  
		speedlms_url = "http://#{self.speedlms_subdomain}.speedlms.dev"
	end
	

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  #checks if user is admin
  def is_admin?
  	if self.role == ROLE[:admin]
  		return true
  	else
  	  return false
  	end
  end
  
  #checks if user is owner
  def is_owner?
  	if self.role == ROLE[:owner]
  		return true
  	else
  	  return false
  	end
  end
  
  #deletes pcode generated when user has requested forgot password functionality.
  def delete_pcode
    self.pcode = nil
    self.save
  end

  protected
    #Encrypts the user password with Digest/SHA1.
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    #checks if password is required for validation
    def password_required?
      not_openid? && (crypted_password.blank? || !password.blank?)
    end
    
    #checks for non-openid login
    def not_openid?
      identity_url.blank?
    end
    
end

