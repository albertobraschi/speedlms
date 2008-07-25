require 'digest/sha1'
class User < ActiveRecord::Base
	
	belongs_to :resource, :polymorphic => true

  RESOURCE_TYPE = {:admin => "Admin", :owner => "Owner", :tutor => "Tutor", :student => "Student"}
  
  attr_accessor :password, :tutor_login, :tutor_email
  
  # Prevents a user from submitting a crafted form that bypasses activation
  # Anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :pcode, :resource_type, :resource_id, :lastname, :firstname
  
	validates_presence_of     :firstname, :lastname	
  validates_presence_of     :login, :email, 
  													:if => :not_openid?  													
  validates_presence_of     :password, :password_confirmation, 
  													:if => :password_required? 
  validates_length_of       :password, 
  													:within => 4..40, 
  													:if => (:password_required? and Proc.new{|a| a.password.length > 0 if a.password})
  validates_confirmation_of :password,                   
  													:if => :password_required?
  validates_length_of       :login,    
  													:within => 3..40, 
  													:if => (:not_openid? and Proc.new{ |a| a.login.length > 0 if a.login})
  validates_length_of       :email,    
  													:within => 3..40, 
  													:if => (:not_openid? and Proc.new{|a| a.email.length > 0 if a.email}) 
  validates_format_of 			:email, 
  													:with =>%r{^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$}, 
                      			:if => Proc.new{|a| a.email.length > 0 if a.email} 
  validates_uniqueness_of   :login, :email, 
  													:if => (:not_openid? and Proc.new{|a| a.resource_type == RESOURCE_TYPE[:owner]})	         
  validates_associated 			:resource 
              			                   
  before_save 							:encrypt_password

	#Validates login and email of a Tutor in scope of his/her Owner.
	#Tutors may have same login,email for different Owners but unique login,email for same Owners.
  def validate
  	if self.resource_type == RESOURCE_TYPE[:tutor]
			current_user
			@owner = current_user.resource
			@tutors = Tutor.find(:all, :conditions => ["owner_id = ?",@owner.id])
			#@Tutor_users should not remain nil while using with << method.
			@tutor_users = []
			if @tutors
				@tutors.each do |tutor|
					@tutor_users << tutor.user
				end
			end
			#Finds all Users who are not Tutor.			
			@non_tutors = User.find(:all, :conditions => ["resource_type != ?",'Tutor'])
			#Combines two arrays (@tutor_users and @non_tutors) into one array and checks if login available.
			for user in @tutor_users.concat(@non_tutors) 				
				errors.add(:login, "has already been taken.") if self.login == user.login
				errors.add(:email, "has already been taken.") if self.email == user.email
			end			
  	end
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil. 
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  
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

  #Sets remember_token expiry time.
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # It sets the field required for remembering User between browser closes
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
  
  #Destroys remember_token and its expiry time
  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  #Checks if user is Admin.
  def is_admin?
  	if self.resource_type == RESOURCE_TYPE[:admin]
  		return true
  	else
  	  return false
  	end
  end
  
  #Checks if user is Owner.
  def is_owner?
  	if self.resource_type == RESOURCE_TYPE[:owner]
  		return true
  	else
  	  return false
  	end
  end
  
  #Checks if user is Tutor.
  def is_tutor?
  	if self.resource_type == RESOURCE_TYPE[:tutor]
  		return true
  	else
  	  return false
  	end
  end
  
  #Checks if user is Student.
  def is_student?
  	if self.resource_type == RESOURCE_TYPE[:student]
  		return true
  	else
  	  return false
  	end
  end
  
  
  #Generates pcode for an User when he has requested for forgot password functionality.
  def generate_pcode
    self.pcode = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join )
    self.save
  end  
  
  #Deletes pcode generated after user has requested forgot password functionality.
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
      
    #Checks if password is required for validation
    def password_required?
      not_openid? && (crypted_password.blank? || !password.blank?)
    end
    
    #Checks for non-openid login
    def not_openid?
      identity_url.blank?
    end
    
end

