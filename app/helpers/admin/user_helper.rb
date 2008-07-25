module Admin::UserHelper

	#Overrides Active Scaffold to take password of an User in a password field.
  def password_form_column(record, input_name)
    password_field :record, :password, :name => input_name, :size => 20
  end

  #Overrides Active Scaffold to take password confirmation of an User in a password field.  
  def password_confirmation_form_column(record, input_name)
    password_field :record, :password_confirmation, :name => input_name, :size => 20
  end
end
