module Admin::UserHelper

	#overrides active scaffold to show password of user form as password field.
  def password_form_column(record, input_name)
    password_field :record, :password, :name => input_name, :size => 20
  end

  #overrides active scaffold to show password confirmation of user form as password field.  
  def password_confirmation_form_column(record, input_name)
    password_field :record, :password_confirmation, :name => input_name, :size => 20
  end
end
